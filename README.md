# 🌲 ecolog.nvim (Beta)

<div align="center">

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)

Ecolog (эколог) - your environment guardian in Neovim. Named after the Russian word for "environmentalist", this plugin protects and manages your environment variables with the same care an ecologist shows for nature.

A Neovim plugin for seamless environment variable integration and management. Provides intelligent autocompletion, type checking, and value peeking for environment variables in your projects. All in one place.

![CleanShot 2025-01-03 at 21 20 37](https://github.com/user-attachments/assets/f19c9979-7334-44ac-8845-77db2e93d187)

</div>

## Table of Contents

- [Installation](#-installation)
  - [Plugin Setup](#plugin-setup)
- [Features](#-features)
- [Usage](#-usage)
  - [Available Commands](#available-commands)
- [Environment File Priority](#-environment-file-priority)
- [Shell Variables Integration](#-shell-variables-integration)
  - [Basic Usage](#basic-usage)
  - [Advanced Configuration](#advanced-configuration)
  - [Configuration Options](#configuration-options)
  - [Features](#features)
  - [Best Practices](#best-practices)
- [Custom Environment File Patterns](#-custom-environment-file-patterns)
  - [Basic Usage](#basic-usage-1)
  - [Pattern Format](#pattern-format)
  - [Examples](#examples)
  - [Features](#features-1)
- [Custom Sort Function](#-custom-sort-function)
  - [Basic Usage](#basic-usage-2)
  - [Examples](#examples-1)
  - [Features](#features-2)
- [Integrations](#-integrations)
  - [Nvim-cmp Integration](#nvim-cmp-integration)
  - [Blink-cmp Integration](#blink-cmp-integration)
  - [LSP Integration](#lsp-integration-experimental)
  - [LSP Saga Integration](#lsp-saga-integration)
  - [Telescope Integration](#telescope-integration)
  - [FZF Integration](#fzf-integration)
  - [Snacks Integration](#snacks-integration)
  - [Statusline Integration](#statusline-integration)
- [Shelter Previewers](#-shelter-previewers)
  - [Telescope Previewer](#telescope-previewer)
  - [FZF Previewer](#fzf-previewer)
  - [Snacks Previewer](#snacks-previewer)
- [Shelter Mode](#️-shelter-mode)
  - [Configuration](#-configuration)
  - [Features](#-features-1)
    - [Module-specific Masking](#module-specific-masking)
    - [Partial Masking](#partial-masking)
  - [Commands](#-commands)
  - [Example](#-example)
  - [Pattern-based Protection](#pattern-based-protection)
  - [Customization](#-customization)
  - [Best Practices](#-best-practices)
- [Ecolog Types](#-ecolog-types)
  - [Type Configuration](#type-configuration)
  - [Custom Type Definition](#custom-type-definition)
- [Tips](#-tips)
- [Theme Integration](#-theme-integration)
- [Author Setup](#️-author-setup)
- [Comparisons](#-comparisons)
  - [Environment Variable Completion](#environment-variable-completion-vs-cmp-dotenv)
  - [Security Features](#security-features-vs-cloaknvim)
  - [Environment Management](#environment-management-vs-telescope-envnvim)
  - [File Management](#file-management-vs-dotenvnvim)
  - [Key Benefits of ecolog.nvim](#key-benefits-of-ecolognvim)
- [Contributing](#-contributing)
- [License](#-license)

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

### Plugin Setup

```lua
{
  'philosofonusus/ecolog.nvim',
  dependencies = {
    'hrsh7th/nvim-cmp', -- Optional: for autocompletion support (recommended)
  },
  -- Optional: you can add some keybindings
  -- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
  keys = {
    { '<leader>ge', '<cmd>EcologGoto<cr>', desc = 'Go to env file' },
    { '<leader>ep', '<cmd>EcologPeek<cr>', desc = 'Ecolog peek variable' },
    { '<leader>es', '<cmd>EcologSelect<cr>', desc = 'Switch env file' },
  },
  -- Lazy loading is done internally
  lazy = false,
  opts = {
    integrations = {
        -- WARNING: for both cmp integrations see readme section below
        nvim_cmp = true, -- If you dont plan to use nvim_cmp set to false, enabled by default
        -- If you are planning to use blink cmp uncomment this line
        -- blink_cmp = true,
    },
    -- Enables shelter mode for sensitive values
    shelter = {
        configuration = {
            -- Partial mode configuration:
            -- false: completely mask values (default)
            -- true: use default partial masking settings
            -- table: customize partial masking
            -- partial_mode = false,
            -- or with custom settings:
            partial_mode = {
                show_start = 3,    -- Show first 3 characters
                show_end = 3,      -- Show last 3 characters
                min_mask = 3,      -- Minimum masked characters
            },
            mask_char = "*",   -- Character used for masking
        },
        modules = {
            cmp = true,       -- Enabled to mask values in completion
            peek = false,      -- Enable to mask values in peek view
            files = true, -- Enabled to mask values in file buffers
            telescope = false, -- Enable to mask values in telescope integration
            telescope_previewer = false, -- Enable to mask values in telescope preview buffers
            fzf = false,       -- Enable to mask values in fzf picker
            fzf_previewer = false, -- Enable to mask values in fzf preview buffers
            snacks_previewer = false,    -- Enable to mask values in snacks previewer
            snacks = false,    -- Enable to mask values in snacks picker
        }
    },
    -- true by default, enables built-in types (database_url, url, etc.)
    types = true,
    path = vim.fn.getcwd(), -- Path to search for .env files
    preferred_environment = "development", -- Optional: prioritize specific env files
    -- Controls how environment variables are extracted from code and how cmp works
    provider_patterns = true, -- true by default, when false will not check provider patterns
  },
}
```

To use the latest features and improvements, you can use the beta branch:

```lua
{
  'philosofonusus/ecolog.nvim',
  branch = 'beta',
  -- ... rest of your configuration
}
```

> Even though beta branch may contain more experimental changes, new and shiny features will appear faster here.
> Consider using it as a contribution to the development of the main branch. Since you can share your feedback.

Setup auto-completion with `nvim-cmp`:

```lua
require('cmp').setup({
  sources = {
    { name = 'ecolog' },
    -- your other sources...
  },
```

If you use `blink.cmp` see [Blink-cmp Integration guide](#blink-cmp-integration)

## ✨ Features

🔍 **Advanced Environment Variable Management**

- Intelligent variable detection across multiple languages
- Real-time file monitoring and cache updates
- Support for custom environment file patterns
- Priority-based environment file loading
- Shell variables integration
- vim.env synchronization

🤖 **Smart Autocompletion**

- Context-aware suggestions with nvim-cmp and blink-cmp
- Type-safe completions with validation
- Intelligent provider detection
- Language-specific completion triggers
- Comment and metadata support in completions

🛡️ **Enhanced Security Features**

- Configurable shelter mode for sensitive data
- Partial masking with customizable patterns
- Per-feature security controls
- Real-time visual masking
- Temporary value reveal functionality
- Screen sharing protection

🔄 **Integrations**

- LSP integration for hover and definition
- Telescope integration with fuzzy finding
- FZF integration with preview support
- LSP Saga integration
- Custom provider API for language support

📁 **Multi-Environment Support**

- Multiple .env file handling
- Custom file pattern matching
- Priority-based loading system
- Environment-specific configurations
- Custom sort functions for file priority

💡 **Type System**

- Built-in type validation
- Custom type definitions
- Pattern-based type detection
- Value transformation support
- Type-aware completion and validation

🎨 **UI/UX Features**

- Theme integration with existing colorschemes
- Customizable highlighting
- Rich preview windows
- Inline documentation
- Status indicators

## 🚀 Usage

### Available Commands

| Command                                    | Description                                                                           |
| ------------------------------------------ | ------------------------------------------------------------------------------------- |
| `:EcologPeek [variable_name]`              | Peek at environment variable value and metadata                                       |
| `:EcologPeek`                              | Peek at environment variable under cursor                                             |
| `:EcologRefresh`                           | Refresh environment variable cache                                                    |
| `:EcologSelect`                            | Open a selection window to choose environment file                                    |
| `:EcologGoto`                              | Open selected environment file in buffer                                              |
| `:EcologGotoVar`                           | Go to specific variable definition in env file                                        |
| `:EcologGotoVar [variable_name]`           | Go to specific variable definition in env file with variable under cursor             |
| `:EcologShelterToggle [command] [feature]` | Control shelter mode for masking sensitive values                                     |
| `:EcologShelterLinePeek`                   | Temporarily reveal value on current line in env file                                  |
| `:Telescope ecolog env`                    | Alternative way to open Telescope picker                                              |
| `:EcologFzf`                               | Alternative way to open fzf-lua picker (must have fzf-lua installed)                  |
| `:EcologSnacks`                            | Open environment variables picker using snacks.nvim (must have snacks.nvim installed) |
| `:EcologEnvGet`                            | Get the value of a specific environment variable(must enable vim_env)                 |
| `:EcologCopy [variable_name]`              | Copy raw value of environment variable to clipboard                                   |
| `:EcologCopy`                              | Copy raw value of environment variable under cursor to clipboard                      |

## 📝 Environment File Priority

Files are loaded in the following priority order:

1. `.env.{preferred_environment}` (if preferred_environment is set)
2. `.env`
3. Other `.env.*` files (alphabetically)

## 🔌 Shell Variables Integration

Ecolog can load environment variables directly from your shell environment. This is useful when you want to:

- Access system environment variables
- Work with variables set by your shell profile
- Handle dynamic environment variables

#### Basic Usage

Enable shell variable loading with default settings:

```lua
require('ecolog').setup({
  load_shell = true
})
```

#### Advanced Configuration

For more control over shell variable handling:

```lua
require('ecolog').setup({
  load_shell = {
    enabled = true,     -- Enable shell variable loading
    override = false,   -- When false, .env files take precedence over shell variables
    -- Optional: filter specific shell variables
    filter = function(key, value)
      -- Example: only load specific variables
      return key:match("^(PATH|HOME|USER)$") ~= nil
    end,
    -- Optional: transform shell variables before loading
    transform = function(key, value)
      -- Example: prefix shell variables for clarity
      return "[shell] " .. value
    end
  }
})
```

#### Configuration Options

| Option      | Type          | Default | Description                                                |
| ----------- | ------------- | ------- | ---------------------------------------------------------- |
| `enabled`   | boolean       | `false` | Enable/disable shell variable loading                      |
| `override`  | boolean       | `false` | When true, shell variables take precedence over .env files |
| `filter`    | function\|nil | `nil`   | Optional function to filter which shell variables to load  |
| `transform` | function\|nil | `nil`   | Optional function to transform shell variable values       |

#### Features

- Full integration with all Ecolog features (completion, peek, shelter mode)
- Shell variables are marked with "shell" as their source
- Configurable precedence between shell and .env file variables
- Optional filtering and transformation of shell variables
- Type detection and value transformation support

#### Best Practices

1. Use `filter` to limit which shell variables are loaded to avoid cluttering
2. Consider using `transform` to clearly mark shell-sourced variables
3. Be mindful of the `override` setting when working with both shell and .env variables
4. Apply shelter mode settings to shell variables containing sensitive data

## 💡 vim.env Integration

Ecolog can automatically sync your environment variables with Neovim's built-in `vim.env` table, making them available to any Neovim process or plugin.

### Configuration

Enable vim.env module in your setup:

```lua
{
  vim_env = true, -- false by default
}
```

### Features

- Automatically syncs environment variables to `vim.env`
- Updates `vim.env` in real-time when environment files change
- Cleans up variables when they are removed from the environment file
- Provides commands to inspect the current state

### Commands

| Command         | Description                                      |
| --------------- | ------------------------------------------------ |
| `:EcologEnvGet` | Get the value of a specific environment variable |

### Example

```lua
-- In your config
require('ecolog').setup({
  vim_env = true,
  -- ... other options
})

-- After setup, variables from your .env file will be available in vim.env:
print(vim.env.DATABASE_URL) -- prints your database URL
print(vim.env.API_KEY)      -- prints your API key
```

### Provider Patterns

The `provider_patterns` option controls how environment variables are extracted from your code and how completion works. It can be configured in two ways:

1. As a boolean (for backward compatibility):

   ```lua
   provider_patterns = true  -- Enables both extraction and completion with language patterns
   -- or
   provider_patterns = false -- Disables both, falls back to word under cursor and basic completion
   ```

2. As a table for fine-grained control:
   ```lua
   provider_patterns = {
     extract = true,  -- Controls variable extraction from code
     cmp = true      -- Controls completion behavior
   }
   ```

#### Extract Mode

The `extract` field controls how variables are extracted from code for features like peek, goto definition, etc:

- When `true` (default): Only recognizes environment variables through language-specific patterns

  - Example: In JavaScript, only matches `process.env.MY_VAR` or `import.meta.env.MY_VAR`
  - Example: In Python, only matches `os.environ.get('MY_VAR')` or `os.environ['MY_VAR']`

- When `false`: Falls back to the word under cursor if no language provider matches
  - Useful when you want to peek at any word that might be an environment variable
  - Less strict but might give false positives

#### Completion Mode

The `cmp` field controls how completion behaves:

- When `true` (default):

  - Uses language-specific triggers (e.g., `process.env.` in JavaScript)
  - Only completes in valid environment variable contexts
  - Formats completions according to language patterns

- When `false`:
  - Uses a basic trigger (any character)
  - Completes environment variables anywhere
  - Useful for more flexible but less context-aware completion

#### Example Configurations

1. Default behavior (strict mode):

   ```lua
   provider_patterns = {
     extract = true,  -- Only extract vars from language patterns
     cmp = true      -- Only complete in valid contexts
   }
   ```

2. Flexible extraction, strict completion:

   ```lua
   provider_patterns = {
     extract = false,  -- Extract any word as potential var
     cmp = true       -- Only complete in valid contexts
   }
   ```

3. Strict extraction, flexible completion:

   ```lua
   provider_patterns = {
     extract = true,   -- Only extract vars from language patterns
     cmp = false      -- Complete anywhere
   }
   ```

4. Maximum flexibility:
   ```lua
   provider_patterns = {
     extract = false,  -- Extract any word as potential var
     cmp = false      -- Complete anywhere
   }
   ```

This affects all features that extract variables from code (peek, goto definition, etc.) and how completion behaves.

## 💡 Custom Environment File Patterns

Ecolog supports custom patterns for matching environment files. This allows you to define your own naming conventions beyond the default `.env*` pattern.

#### Basic Usage

Set a single custom pattern:

```lua
require('ecolog').setup({
  env_file_pattern = "^config/.+%.env$" -- Matches any .env file in the config directory
})
```

Use multiple patterns:

```lua
require('ecolog').setup({
  env_file_pattern = {
    "^config/.+%.env$",     -- Matches .env files in config directory
    "^environments/.+%.env$" -- Matches .env files in environments directory
  }
})
```

#### Pattern Format

- Patterns use Lua pattern matching syntax
- Patterns are relative to the project root (`path` option)
- Default patterns (`.env*`) are always included as fallback

#### Examples

```lua
env_file_pattern = {
  "^%.env%.%w+$",          -- Matches .env.development, .env.production, etc.
  "^config/env%.%w+$",     -- Matches config/env.development, config/env.production, etc.
  "^%.env%.local%.%w+$",   -- Matches .env.local.development, .env.local.production, etc.
  "^environments/.+%.env$"  -- Matches any file ending in .env in the environments directory
}
```

#### Features

- Multiple pattern support
- Directory-specific matching
- Flexible naming conventions
- Fallback to default patterns
- Real-time file monitoring for custom patterns

## 🔄 Custom Sort Function

Ecolog allows you to customize how environment files are sorted using the `sort_fn` option. This is useful when you need specific ordering beyond the default alphabetical sorting.

#### Basic Usage

```lua
require('ecolog').setup({
  sort_fn = function(a, b)
    -- Sort by file size (smaller files first)
    local a_size = vim.fn.getfsize(a)
    local b_size = vim.fn.getfsize(b)
    return a_size < b_size
  end
})
```

#### Examples

1. **Priority-based sorting**:

```lua
sort_fn = function(a, b)
  local priority = {
    [".env.production"] = 1,
    [".env.staging"] = 2,
    [".env.development"] = 3,
    [".env"] = 4
  }
  local a_name = vim.fn.fnamemodify(a, ":t")
  local b_name = vim.fn.fnamemodify(b, ":t")
  return (priority[a_name] or 99) < (priority[b_name] or 99)
end
```

2. **Sort by modification time**:

```lua
sort_fn = function(a, b)
  local a_time = vim.fn.getftime(a)
  local b_time = vim.fn.getftime(b)
  return a_time > b_time  -- Most recently modified first
end
```

3. **Sort by environment type**:

```lua
sort_fn = function(a, b)
  -- Extract environment type from filename
  local function get_env_type(file)
    local name = vim.fn.fnamemodify(file, ":t")
    return name:match("^%.env%.(.+)$") or ""
  end
  return get_env_type(a) < get_env_type(b)
end
```

#### Features

- Custom sorting logic for environment files
- Access to full file paths for advanced sorting
- Compatible with `preferred_environment` option
- Real-time sorting when files change

## 🔌 Integrations

### Nvim-cmp Integration

Add `ecolog` to your nvim-cmp sources:

```lua
require('cmp').setup({
  sources = {
    { name = 'ecolog' },
    -- your other sources...
  },
```

})

Nvim-cmp integration is enabled by default. To disable it:

```lua
require('ecolog').setup({
  integrations = {
    nvim_cmp = false,
  },
})
```

### Blink-cmp Integration

PS: When blink_cmp is enabled, nvim_cmp is disabled by default.

Ecolog provides an integration with [blink.cmp](https://github.com/saghen/blink.cmp) for environment variable completions. To enable it:

1. Enable the integration in your Ecolog setup:

```lua
require('ecolog').setup({
  integrations = {
    blink_cmp = true,
  },
})
```

2. Configure Blink CMP to use the Ecolog source:

```lua
{
  "saghen/blink.cmp",
  opts = {
    sources = {
      default = { 'ecolog', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        ecolog = { name = 'ecolog', module = 'ecolog.integrations.cmp.blink_cmp' },
      },
    },
  },
}
```

### LSP Integration (Experimental)

> ⚠️ **Warning**: The LSP integration is currently experimental and may interfere with your existing LSP setup. Use with caution.

Ecolog provides optional LSP integration that enhances the hover and definition functionality for environment variables. When enabled, it will:

- Show environment variable values when hovering over them
- Jump to environment variable definitions using goto-definition

meaning you dont need any custom keymaps

#### Setup

To enable LSP integration, add this to your Neovim configuration:

```lua
require('ecolog').setup({
    integrations = {
        lsp = true,
    }
})
```

PS: If you're using lspsaga, please see section [LSP Saga Integration](#lsp-saga-integration) don't use lsp integration use one or the other.

#### Features

- **Hover Preview**: When you hover (K) over an environment variable, it will show the value and metadata in a floating window
- **Goto Definition**: Using goto-definition (gd) on an environment variable will jump to its definition in the .env file

#### Known Limitations

1. The integration overrides the default LSP hover and definition handlers
2. May conflict with other plugins that modify LSP hover behavior
3. Performance impact on LSP operations (though optimized and should be unnoticable)

#### Disabling LSP Integration

If you experience any issues, you can disable the LSP integration:

```lua
require('ecolog').setup({
    integrations = {
        lsp = false,
    }
})
```

Please report such issues on our GitHub repository

### LSP Saga Integration

Ecolog provides integration with [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) that enhances hover and goto-definition functionality for environment variables while preserving Saga's features for other code elements.

#### Setup

To enable LSP Saga integration, add this to your configuration:

```lua
require('ecolog').setup({
    integrations = {
        lspsaga = true,
    }
})
```

PS: If you're using lspsaga then don't use lsp integration use one or the other.

#### Features

The integration adds two commands that intelligently handle both environment variables and regular code:

1. **EcologSagaHover**:

   - Shows environment variable value when hovering over env vars
   - Falls back to Saga's hover for other code elements
   - Automatically replaces existing Saga hover keymaps

2. **EcologSagaGD** (Goto Definition):
   - Jumps to environment variable definition in .env file
   - Uses Saga's goto definition for other code elements
   - Automatically replaces existing Saga goto-definition keymaps

> 💡 **Note**: When enabled, the integration automatically detects and updates your existing Lspsaga keymaps to use Ecolog's enhanced functionality. No manual keymap configuration required!

#### Example Configuration

```lua
{
  'philosofonusus/ecolog.nvim',
  dependencies = {
    'nvimdev/lspsaga.nvim',
    'hrsh7th/nvim-cmp',
  },
  opts = {
    integrations = {
      lspsaga = true,
    }
  },
}
```

> 💡 **Note**: The LSP Saga integration provides a smoother experience than the experimental LSP integration if you're already using Saga in your setup.

### Telescope Integration

First, load the extension:

```lua
require('telescope').load_extension('ecolog')
```

Then configure it in your Telescope setup (optional):

```lua
require('telescope').setup({
  extensions = {
    ecolog = {
      shelter = {
        -- Whether to show masked values when copying to clipboard
        mask_on_copy = false,
      },
      -- Default keybindings
      mappings = {
        -- Key to copy value to clipboard
        copy_value = "<C-y>",
        -- Key to copy name to clipboard
        copy_name = "<C-n>",
        -- Key to append value to buffer
        append_value = "<C-a>",
        -- Key to append name to buffer (defaults to <CR>)
        append_name = "<CR>",
      },
    }
  }
})
```

### FZF Integration

Ecolog integrates with [fzf-lua](https://github.com/ibhagwan/fzf-lua) to provide a fuzzy finder interface for environment variables.

#### Setup

```lua
require('ecolog').setup({
  integrations = {
    fzf = {
      shelter = {
        mask_on_copy = false, -- Whether to mask values when copying
      },
      mappings = {
        copy_value = "ctrl-y",  -- Copy variable value to clipboard
        copy_name = "ctrl-n",   -- Copy variable name to clipboard
        append_value = "ctrl-a", -- Append value at cursor position
        append_name = "enter",   -- Append name at cursor position
      },
    }
  }
})
```

You can trigger the FZF picker using `:EcologFzf` command.

#### Features

- 🔍 Fuzzy search through environment variables
- 📋 Copy variable names or values to clipboard
- ⌨️ Insert variables into your code
- 🛡️ Integrated with shelter mode for sensitive data protection
- 📝 Real-time updates when environment files change

#### Usage

Open the environment variables picker:

```vim
:EcologFzf
```

#### Default Keymaps

| Key       | Action                  |
| --------- | ----------------------- |
| `<Enter>` | Insert variable name    |
| `<C-y>`   | Copy value to clipboard |
| `<C-n>`   | Copy name to clipboard  |
| `<C-a>`   | Append value to buffer  |

All keymaps are customizable through the configuration.

### Snacks Integration

Ecolog integrates with [snacks.nvim](https://github.com/folke/snacks.nvim) to provide a modern and beautiful picker interface for environment variables.

#### Setup

```lua
require('ecolog').setup({
  integrations = {
    snacks = {
      shelter = {
        mask_on_copy = false, -- Whether to mask values when copying
      },
      keys = {
        copy_value = "<C-y>",  -- Copy variable value to clipboard
        copy_name = "<C-u>",   -- Copy variable name to clipboard
        append_value = "<C-a>", -- Append value at cursor position
        append_name = "<CR>",   -- Append name at cursor position
      },
      layout = {  -- Any Snacks layout configuration
        preset = "dropdown",
        preview = false,
      },
    }
  }
})
```

You can trigger the Snacks picker using `:EcologSnacks` command.

#### Features

- 🎨 Beautiful VSCode-like interface
- 🔍 Real-time fuzzy search
- 📋 Copy variable names or values to clipboard
- ⌨️ Insert variables into your code
- 🛡️ Integrated with shelter mode for sensitive data protection
- 📝 Live updates when environment files change
- 🎯 Syntax highlighting for better readability

#### Usage

Open the environment variables picker:

```vim
:EcologSnacks
```

#### Default Keymaps

| Key     | Action                  |
| ------- | ----------------------- |
| `<CR>`  | Insert variable name    |
| `<C-y>` | Copy value to clipboard |
| `<C-u>` | Copy name to clipboard  |
| `<C-a>` | Append value to buffer  |

All keymaps are customizable through the configuration.

### Statusline Integration

Ecolog provides a built-in statusline component that shows your current environment file, variable count, and shelter mode status. It supports both native statusline and lualine integration.

#### Setup

```lua
require('ecolog').setup({
  integrations = {
    snacks = {
      shelter = {
        mask_on_copy = false, -- Whether to mask values when copying
      },
      keys = {
        copy_value = "<C-y>",  -- Copy variable value to clipboard
        copy_name = "<C-n>",   -- Copy variable name to clipboard
        append_value = "<C-a>", -- Append value at cursor position
        append_name = "<CR>",   -- Append name at cursor position
      },
    }
  }
})
```

You can trigger the Snacks picker using `:EcologSnacks` command.

#### Features

- 🎨 Beautiful VSCode-like interface
- 🔍 Real-time fuzzy search
- 📋 Copy variable names or values to clipboard
- ⌨️ Insert variables into your code
- 🛡️ Integrated with shelter mode for sensitive data protection
- 📝 Live updates when environment files change
- 🎯 Syntax highlighting for better readability

#### Usage

Open the environment variables picker:

```vim
:EcologSnacks
```

#### Default Keymaps

| Key     | Action                  |
| ------- | ----------------------- |
| `<CR>`  | Insert variable name    |
| `<C-y>` | Copy value to clipboard |
| `<C-n>` | Copy name to clipboard  |
| `<C-a>` | Append value to buffer  |

All keymaps are customizable through the configuration.

### 🔍 Shelter Previewers

`ecolog.nvim` integrates with various file pickers to provide a secure way to use file picker without leaking sensitive data, when searching for files.

- Secure environment file previews
- Configurable masking behavior
- Minimal memory footprint
- Efficient buffer management
- Integration with fzf-lua, telescope and snacks.picker

#### Telescope Previewer

Configuration:

```lua
require('ecolog').setup({
  shelter = {
    modules = {
      telescope_previewer = true, -- Mask values in telescope preview buffers
    }
  }
})
```

#### FZF Previewer

Configuration:

```lua
require('ecolog').setup({
  shelter = {
    modules = {
      fzf_previewer = true, -- Mask values in fzf preview buffers
    }
  }
})
```

#### Snacks Previewer

Configuration:

```lua
require('ecolog').setup({
  shelter = {
    modules = {
      snacks_previewer = true,    -- Mask values in snacks previewer
    }
  }
})
```

## 🛡️ Shelter Mode

Shelter mode provides a secure way to work with sensitive environment variables by masking their values in different contexts. This feature helps prevent accidental exposure of sensitive data like API keys, passwords, tokens, and other credentials.

### 🔧 Configuration

```lua
require('ecolog').setup({
    shelter = {
        configuration = {
            -- Partial mode configuration:
            -- false: completely mask values (default)
            -- true: use default partial masking settings
            -- table: customize partial masking
            -- partial_mode = false,
            -- or with custom settings:
            partial_mode = {
                show_start = 3,    -- Show first 3 characters
                show_end = 3,      -- Show last 3 characters
                min_mask = 3,      -- Minimum masked characters
            },
            mask_char = "*",   -- Character used for masking
        },
        modules = {
            cmp = false,       -- Mask values in completion
            peek = false,      -- Mask values in peek view
            files = false,     -- Mask values in files
            telescope = false, -- Mask values in telescope integration
            telescope_previewer = false, -- Mask values in telescope preview buffers
            fzf = false,       -- Mask values in fzf picker
            fzf_previewer = false, -- Mask values in fzf preview buffers
            snacks = false,    -- Mask values in snacks picker
            snacks_previewer = false,    -- Mask values in snacks previewer
        }
    },
    path = vim.fn.getcwd(), -- Path to search for .env files
    preferred_environment = "development", -- Optional: prioritize specific env files
})
```

### 🎯 Features

#### Module-specific Masking

1. **Completion Menu (`cmp = true`)**

   - Masks values in nvim-cmp completion menu
   - Protects sensitive data during autocompletion

2. **Peek View (`peek = true`)**

   - Masks values when using EcologPeek command
   - Allows secure variable inspection

3. **File View (`files = true`)**

   - Masks values directly in .env files
   - Use `:EcologShelterLinePeek` to temporarily reveal values

4. **Telescope Preview (`telescope_previewer = true`)**

   - Masks values in telescope preview buffers
   - Automatically applies to any `.env` file previewed in telescope with support of custom env file patterns
   - Maintains masking state across buffer refreshes

5. **FZF Preview (`fzf_previewer = true`)**

   - Masks values in fzf-lua preview buffers
   - Automatically applies to any `.env` file previewed in fzf-lua with support of custom env file patterns
   - Supports all fzf-lua commands that show previews (files, git_files, live_grep, etc.)
   - Maintains masking state across buffer refreshes
   - Optimized for performance with buffer content caching

6. **FZF Picker (`fzf = true`)**

   - Masks values in fzf-lua picker

7. **Telescope Integration (`telescope = true`)**

   - Masks values in telescope picker from integration

8. **Snacks Integration (`snacks = true`, `snacks_previewer = true`)**
   - Masks values in snacks picker and previewer
   - Provides secure browsing of environment variables

#### Partial Masking

Three modes of operation:

1. **Full Masking (Default)**

   ```lua
   partial_mode = false
   -- Example: "my-secret-key" -> "************"
   ```

2. **Default Partial Masking**

   ```lua
   partial_mode = true
   -- Example: "my-secret-key" -> "my-***-key"
   ```

3. **Custom Partial Masking**
   ```lua
   partial_mode = {
       show_start = 4,    -- Show more start characters
       show_end = 2,      -- Show fewer end characters
       min_mask = 3,      -- Minimum mask length
   }
   -- Example: "my-secret-key" -> "my-s***ey"
   ```

### 🎮 Commands

`:EcologShelterToggle` provides flexible control over shelter mode:

1. Basic Usage:

   ```vim
   :EcologShelterToggle              " Toggle between all-off and initial settings
   ```

2. Global Control:

   ```vim
   :EcologShelterToggle enable       " Enable all shelter modes
   :EcologShelterToggle disable      " Disable all shelter modes
   ```

3. Feature-Specific Control:

   ```vim
   :EcologShelterToggle enable cmp   " Enable shelter for completion only
   :EcologShelterToggle disable peek " Disable shelter for peek only
   :EcologShelterToggle enable files " Enable shelter for file display
   ```

4. Quick Value Reveal:
   ```vim
   :EcologShelterLinePeek           " Temporarily reveal value on current line
   ```
   - Shows the actual value for the current line
   - Value is hidden again when cursor moves away
   - Only works when shelter mode is enabled for files

### 📝 Example

Original `.env` file:

```env
# Authentication
JWT_SECRET=my-super-secret-key
AUTH_TOKEN="bearer 1234567890"

# Database Configuration
DB_HOST=localhost
DB_USER=admin
DB_PASS=secure_password123
```

With full masking (partial_mode = false):

```env
# Authentication
JWT_SECRET=********************
AUTH_TOKEN=******************

# Database Configuration
DB_HOST=*********
DB_USER=*****
DB_PASS=******************
```

#### Partial Masking Examples

With default settings (show_start=3, show_end=3, min_mask=3):

```
"mysecretkey"     -> "mys***key"    # Enough space for min_mask (3) characters
"secret"          -> "******"        # Not enough space for min_mask between shown parts
"api_key"         -> "*******"       # Would only have 1 char for masking, less than min_mask
"very_long_key"   -> "ver*****key"   # Plenty of space for masking
```

The min_mask setting ensures that sensitive values are properly protected by requiring
a minimum number of masked characters between the visible parts. If this minimum
cannot be met, the entire value is masked for security.

### Pattern-based Protection

You can define different masking rules based on variable names or file sources:

```lua
shelter = {
    configuration = {
        -- Pattern-based rules take precedence
        patterns = {
            ["*_KEY"] = "full",      -- Always fully mask API keys
            ["TEST_*"] = "none",     -- Never mask test variables
        },
        -- Source-based rules as fallback
        sources = {
            [".env.*"] = "full",
            [".env.local"] = "none",
            ["shell"] = "none",
        },
    }
}
```

### 🎨 Customization

1. **Custom Mask Character**:

   ```lua
   shelter = {
       configuration = {
          mask_char = "•"  -- Use dots
       }
   }
   -- or
   shelter = {
       configuration = {
          mask_char = "█"  -- Use blocks
       }
   }
   ```

2. **Custom Highlighting**:
   ```lua
   shelter = {
       configuration = {
          highlight_group = "NonText"  -- Use a different highlight group for masked values
       }
   }
   ```

### 💡 Best Practices

1. Enable shelter mode by default for production environments
2. Use file shelter mode during screen sharing or pair programming
3. Enable completion shelter mode to prevent accidental exposure in screenshots
4. Use source-based masking to protect sensitive files
5. Apply stricter masking rules for production and staging environments
6. Keep development and test files less restricted for better workflow

## 🛡 Ecolog Types

Ecolog includes a flexible type system for environment variables with built-in and custom types.

### Type Configuration

Configure types through the `types` option in setup:

```lua
require('ecolog').setup({
  custom_types = {
      semver = {
        pattern = "^v?%d+%.%d+%.%d+%-?[%w]*$",
        validate = function(value)
          local major, minor, patch = value:match("^v?(%d+)%.(%d+)%.(%d+)")
          return major and minor and patch
        end,
      },
     aws_region = {
      pattern = "^[a-z]{2}%-[a-z]+%-[0-9]$",
      validate = function(value)
        local valid_regions = {
          ["us-east-1"] = true,
          ["us-west-2"] = true,
          -- ... etc
        }
        return valid_regions[value] == true
      end
    }
  },
  types = {
    -- Built-in types
    url = true,          -- URLs (http/https)
    localhost = true,    -- Localhost URLs
    ipv4 = true,        -- IPv4 addresses
    database_url = true, -- Database connection strings
    number = true,       -- Integers and decimals
    boolean = true,      -- true/false/yes/no/1/0
    json = true,         -- JSON objects and arrays
    iso_date = true,     -- ISO 8601 dates (YYYY-MM-DD)
    iso_time = true,     -- ISO 8601 times (HH:MM:SS)
    hex_color = true,    -- Hex color codes (#RGB or #RRGGBB)
  }
})
```

You can also:

- Enable all built-in types: `types = true`
- Disable all built-in types: `types = false`
- Enable specific types and add custom ones:

```lua
require('ecolog').setup({
  custom_types = {
    jwt = {
      pattern = "^[A-Za-z0-9%-_]+%.[A-Za-z0-9%-_]+%.[A-Za-z0-9%-_]+$",
      validate = function(value)
        local parts = vim.split(value, ".", { plain = true })
        return #parts == 3
      end
    },
  }
  types = {
    url = true,
    number = true,
  }
})
```

### Custom Type Definition

Each custom type requires:

1. **`pattern`** (required): A Lua pattern string for initial matching
2. **`validate`** (optional): A function for additional validation
3. **`transform`** (optional): A function to transform the value

Example usage in .env files:

```env
VERSION=v1.2.3                  # Will be detected as semver type
REGION=us-east-1               # Will be detected as aws_region type
AUTH_TOKEN=eyJhbG.eyJzd.iOiJ  # Will be detected as jwt type
```

## 💡 Tips

1. **Selective Protection**: Enable shelter mode only for sensitive environments:

   ```lua
   -- In your config
   if vim.fn.getcwd():match("production") then
     require('ecolog').setup({
       shelter = {
           configuration = {
               partial_mode = {
                   show_start = 3,    -- Number of characters to show at start
                   show_end = 3,      -- Number of characters to show at end
                   min_mask = 3,      -- Minimum number of mask characters
               },
               mask_char = "*",   -- Character used for masking
               -- Mask all values from production files
               sources = {
                   [".env.prod"] = "full",
                   [".env.local"] = "partial",
                   ["shell"] = "none",
               },
           },
           modules = {
               cmp = true,       -- Mask values in completion
               peek = true,      -- Mask values in peek view
               files = true,     -- Mask values in files
               telescope = false -- Mask values in telescope
               telescope_previewer = false -- Mask values in telescope preview buffers
           }
       },
       path = vim.fn.getcwd(), -- Path to search for .env files
       preferred_environment = "development", -- Optional: prioritize specific env files
     })
   end
   ```

2. **Source-based Protection**: Use different masking levels based on file sources:

   ```lua
   shelter = {
       configuration = {
           -- Mask values based on their source file
           sources = {
               [".env.prod"] = "full",
               [".env.local"] = "partial",
               ["shell"] = "none",
           },
           -- Pattern-based rules take precedence
           patterns = {
               ["*_KEY"] = "full",      -- Always fully mask API keys
               ["TEST_*"] = "none",     -- Never mask test variables
           },
       }
   }
   ```

3. **Custom Masking**: Use different characters for masking:

   ```lua
   shelter = {
       configuration = {
          mask_char = "•"  -- Use dots
       }
   }
   -- or
   shelter = {
       configuration = {
          mask_char = "█"  -- Use blocks
       }
   }
   -- or
   shelter = {
       configuration = {
          highlight_group = "NonText"  -- Use a different highlight group for masked values
       }
   }
   ```

   The `highlight_group` option allows you to customize the highlight group used for masked values. By default, it uses the `Comment` highlight group. You can use any valid Neovim highlight group name.

4. **Temporary Viewing**: Use `:EcologShelterToggle disable` temporarily when you need to view values, then re-enable with `:EcologShelterToggle enable`

5. **Security Best Practices**:
   - Enable shelter mode by default for production environments
   - Use file shelter mode during screen sharing or pair programming
   - Enable completion shelter mode to prevent accidental exposure in screenshots
   - Use source-based masking to protect sensitive files
   - Apply stricter masking rules for production and staging environments
   - Keep development and test files less restricted for better workflow

## 🎨 Theme Integration

The plugin seamlessly integrates with your current colorscheme:

| Element        | Color Source |
| -------------- | ------------ |
| Variable names | `Identifier` |
| Types          | `Type`       |
| Values         | `String`     |
| Sources        | `Directory`  |

## 🛠️ Author Setup

It's author's (`philosofonusus`) personal setup for ecolog.nvim if you don't want to think much of a setup and reading docs:

```lua
return {
  {
    'philosofonusus/ecolog.nvim',
    keys = {
      { '<leader>ge', '<cmd>EcologGoto<cr>', desc = 'Go to env file' },
      { '<leader>ec', '<cmd>EcologSnacks<cr>', desc = 'Open a picker' },
      { '<leader>eS', '<cmd>EcologSelect<cr>', desc = 'Switch env file' },
      { '<leader>es', '<cmd>EcologShelterToggle<cr>', desc = 'Ecolog shelter toggle' },
    },
    lazy = false,
    opts = {
      preferred_environment = 'local',
      types = true,
      integrations = {
        lspsaga = true,
        nvim_cmp = true,
        statusline = {
          hidden_mode = true,
        },
        snacks = true,
      },
      shelter = {
        configuration = {
          partial_mode = {
            min_mask = 5,
            show_start = 1,
            show_end = 1,
          },
          mask_char = '*',
        },
        modules = {
          files = true,
          peek = false,
          snacks_previewer = true,
          cmp = true,
        },
      },
      path = vim.fn.getcwd(),
    },
  },
}
```

## 🔄 Comparisons

While `ecolog.nvim` has many great and unique features, here are some comparisons with other plugins in neovim ecosystem in **_their specific fields_**:

### Environment Variable Completion (vs [cmp-dotenv](https://github.com/jcha0713/cmp-dotenv))

| Feature                    | ecolog.nvim                                                                                    | cmp-dotenv                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| Language-aware Completion  | ✅ Fully configurable context-aware triggers for multiple languages and filetypes              | ❌ Basic environment variable completion only on every char |
| Type System                | ✅ Built-in type validation and custom types                                                   | ❌ No type system                                           |
| Nvim-cmp support           | ✅ Nvim-cmp integration                                                                        | ✅ Nvim-cmp integration                                     |
| Blink-cmp support          | ✅ Native blink-cmp integration                                                                | ❌ Doesn't support blink-cmp natively                       |
| Documentation Support      | ✅ Rich documentation with type info and source                                                | 🟡 Basic documentation support                              |
| Shell Variable Integration | ✅ Configurable shell variable loading and filtering                                           | 🟡 Basic shell variable support                             |
| Multiple Environment Files | ✅ Priority-based loading with custom sorting and switching between multiple environment files | 🟡 Basic environment variable loading                       |

### Security Features (vs [cloak.nvim](https://github.com/laytan/cloak.nvim))

| Feature                          | ecolog.nvim                                                                             | cloak.nvim                                            |
| -------------------------------- | --------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| Partial Value Masking            | ✅ Configurable partial masking with patterns                                           | 🟡 Full masking only                                  |
| Pattern-based Security           | ✅ Custom patterns for different security levels                                        | 🟡 Basic pattern matching                             |
| Preview Protection               | ✅ Telescope/FZF/Snacks picker preview protection                                       | 🟡 Only Telescope preview protection                  |
| Mask sensitive values on startup | ✅ Full support, never leak environment variables                                       | ❌ Doesn't support masking on startup, flashes values |
| Mask on leave                    | ✅ Supports                                                                             | ✅ Supports                                           |
| Completion disable               | ✅ Supports both blink-cmp and nvim-cmp, configurable                                   | 🟡 Only nvim-cmp and can't disable                    |
| Custom mask and highlights       | ✅ Supports                                                                             | ✅ Supports                                           |
| Performance                      | ✅ Better performance, especially in previewer buffers due to LRU caching               | 🟡 Minimal implementation but also good               |
| Supports custom integrations     | ✅ Supports all ecolog.nvim features telescope-lua, snacks, fzf-lua, cmp, peek and etc. | 🟡 Only works in file buffers and telescope previewer |
| Static mask length               | ❌ Chose not to support it due to neovim limitations                                    | 🟡 Supports but have caveats                          |
| Filetype support                 | 🟡 Supports only `sh` and `.env` files                                                  | ✅ Can work in any filetype                           |

### Environment Management (vs [telescope-env.nvim](https://github.com/LinArcX/telescope-env.nvim))

| Feature                     | ecolog.nvim                                 | telescope-env.nvim      |
| --------------------------- | ------------------------------------------- | ----------------------- |
| Environment Variable Search | ✅ Basic search                             | ✅ Basic search         |
| Customizable keymaps        | ✅ Fully customizable                       | ✅ Fully customizable   |
| Value Preview               | ✅ Protected value preview                  | 🟡 Basic value preview  |
| Multiple Picker Support     | ✅ Telescope, Snacks picker and FZF support | 🟡 Telescope only       |
| Security Features           | ✅ Integrated security in previews          | ❌ No security features |
| Custom Sort/Filter          | ✅ Advanced sorting and filtering options   | 🟡 Basic sorting only   |

### File Management (vs [dotenv.nvim](https://github.com/ellisonleao/dotenv.nvim))

| Feature                      | ecolog.nvim                                          | dotenv.nvim                  |
| ---------------------------- | ---------------------------------------------------- | ---------------------------- |
| Environment File Detection   | ✅ Custom patterns and priority-based loading        | 🟡 Basic env file loading    |
| Multiple Environment Support | ✅ Advanced environment file switching               | 🟡 Basic environment support |
| Shell Variable Integration   | ✅ Configurable shell variable loading and filtering | ❌ No shell integration      |

### Key Benefits of ecolog.nvim

1. **All-in-One Solution**: Most importantly it combines features from multiple plugins into a cohesive environment management suite which also opens new possibilties
2. **Language Intelligence**: Provides language-specific completions and integrations
3. **Advanced Security**: Offers the most comprehensive security features for sensitive data
4. **Type System**: Unique type system for validation and documentation
5. **Rich Integrations**: Seamless integration with LSP, Telescope, FZF, EcologPeek and more
6. **Performance**: Optimzed for speed and efficiency in mind
7. **Extensibility**: Custom providers and types for extending functionality

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests

## 📄 License

MIT License - See [LICENSE](./LICENSE) for details.

---

<div align="center">
Made with ❤️ by <a href="https://github.com/philosofonusus">TENTACLE</a>
</div>
