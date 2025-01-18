local M = {}

local api = vim.api
local state = require("ecolog.shelter.state")
local utils = require("ecolog.utils")
local shelter_utils = require("ecolog.shelter.utils")
local lru_cache = require("ecolog.shelter.lru_cache")

local namespace = api.nvim_create_namespace("ecolog_shelter")

-- Initialize LRU cache with capacity of 100 buffers
local processed_buffers = lru_cache.new(100)

local function process_buffer_chunk(bufnr, lines, start_idx, end_idx, content_hash, filename)
  local chunk_extmarks = {}

  for i = start_idx, math.min(end_idx, #lines) do
    local line = lines[i]
    local key, value, eq_pos = utils.parse_env_line(line)

    if key and value then
      local quote_char = value:match("^([\"'])")
      local actual_value = quote_char and value:match("^" .. quote_char .. "(.-)" .. quote_char) or value

      if actual_value then
        local masked_value = shelter_utils.determine_masked_value(actual_value, {
          partial_mode = state.get_config().partial_mode,
          key = key,
          source = filename,
        })

        if masked_value and #masked_value > 0 then
          if quote_char then
            masked_value = quote_char .. masked_value .. quote_char
          end

          table.insert(chunk_extmarks, {
            i - 1,
            eq_pos,
            {
              virt_text = { { masked_value, masked_value == value and "String" or state.get_config().highlight_group } },
              virt_text_pos = "overlay",
              hl_mode = "combine",
            },
          })
        end
      end
    end
  end

  if #chunk_extmarks > 0 then
    vim.schedule(function()
      for _, mark in ipairs(chunk_extmarks) do
        pcall(api.nvim_buf_set_extmark, bufnr, namespace, mark[1], mark[2], mark[3])
      end
    end)
  end

  -- Process next chunk if needed
  if end_idx < #lines then
    vim.schedule(function()
      process_buffer_chunk(bufnr, lines, end_idx + 1, end_idx + 50, content_hash, filename)
    end)
  else
    processed_buffers:put(bufnr, {
      hash = content_hash,
      timestamp = vim.loop.now(),
    })
  end
end

function M.process_buffer(bufnr)
  if not bufnr or not api.nvim_buf_is_valid(bufnr) then
    return
  end

  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content_hash = vim.fn.sha256(table.concat(lines, "\n"))
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")

  local cached = processed_buffers:get(bufnr)
  if cached and cached.hash == content_hash then
    return
  end

  pcall(api.nvim_buf_set_var, bufnr, "ecolog_masked", true)

  -- Start processing in chunks of 50 lines
  process_buffer_chunk(bufnr, lines, 1, 50, content_hash, filename)
end

---@param bufnr number
---@param filename string
---@param integration_name string
function M.mask_preview_buffer(bufnr, filename, integration_name)
  if not bufnr or not api.nvim_buf_is_valid(bufnr) then
    return
  end

  local config = require("ecolog").get_config and require("ecolog").get_config() or {}
  local is_env_file = shelter_utils.match_env_file(filename, config)

  if not (is_env_file and state.is_enabled(integration_name .. "_previewer")) then
    return
  end

  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content_hash = vim.fn.sha256(table.concat(lines, "\n"))

  local cached = processed_buffers:get(bufnr)
  if cached and cached.hash == content_hash then
    return
  end

  pcall(api.nvim_buf_set_var, bufnr, "ecolog_masked", true)

  -- Start processing in chunks of 50 lines
  process_buffer_chunk(bufnr, lines, 1, 50, content_hash, filename)
end

return M

