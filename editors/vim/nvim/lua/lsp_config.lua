-- ----------------------------------------
-- Mason setup (LSP server management)
-- ----------------------------------------
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",           -- Lua
    "ts_ls",            -- TypeScript/JavaScript/JSX
    "gopls",            -- Go
    "pyright",          -- Python
    "rust_analyzer",    -- Rust
    "html",             -- HTML
    "cssls",            -- CSS
    "jsonls",           -- JSON
    "ruby_lsp",         -- Ruby
    "jdtls",            -- Java
    "kotlin_language_server", -- Kotlin
    "sourcekit",        -- Swift
    "lemminx",          -- XML
    "clangd",           -- C/C++
    "sqlls",            -- SQL
    "bashls",           -- Shell script
    "autotools_ls",     -- Makefile
  },
  automatic_installation = true,
})

-- ----------------------------------------
-- LSP configuration
-- ----------------------------------------
local lspconfig = require("lspconfig")

-- Common on_attach function
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }

  -- LSP keymaps
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)

  -- Diagnostics
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
end

-- LSP capabilities (for ddc.vim integration)
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Setup language servers
local servers = {
  "ts_ls",
  "gopls",
  "pyright",
  "rust_analyzer",
  "html",
  "cssls",
  "jsonls",
  "ruby_lsp",
  "kotlin_language_server",
  "sourcekit",
  "lemminx",
  "sqlls",
  "bashls",
  "autotools_ls"
}

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Special configuration for lua_ls
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Special configuration for jdtls (Java)
lspconfig.jdtls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "jdtls" },
  root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
    },
  },
})

-- Special configuration for clangd (C/C++)
lspconfig.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
})

-- ----------------------------------------
-- Diagnostic configuration
-- ----------------------------------------
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ----------------------------------------
-- Telescope configuration
-- ----------------------------------------
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    find_files = {
      theme = "dropdown"
    }
  },
  extensions = {}
}

-- ----------------------------------------
-- Lualine configuration
-- ----------------------------------------
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

-- ----------------------------------------
-- Bufferline configuration
-- ----------------------------------------
require('bufferline').setup {
  options = {
    numbers = "ordinal",
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = '▎',
      style = 'icon',
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 30,
    max_prefix_length = 30,
    tab_size = 21,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true
      }
    },
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "slant",
    enforce_regular_tabs = true,
    always_show_bufferline = true,
  }
}

-- ----------------------------------------
-- Toggleterm configuration
-- ----------------------------------------
require('toggleterm').setup{
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

-- ----------------------------------------
-- nvim-lint configuration
-- ----------------------------------------
require('lint').linters_by_ft = {
  javascript = {'eslint'},
  typescript = {'eslint'},
  go = {'golangcilint'},
  python = {'pylint'},
  css = {'stylelint'},
  html = {'htmlhint'}
}

-- Auto-lint on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- ----------------------------------------
-- conform.nvim configuration
-- ----------------------------------------
require('conform').setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    go = { "goimports", "gofmt" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})