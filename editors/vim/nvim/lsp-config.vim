" ----------------------------------------
" LSP Configuration
" ----------------------------------------
" モダンなLSP設定のサンプル
" このファイルは段階的にLua化することを推奨

" LSP関連プラグインの追加（install-plugins.vimに追加推奨）
" call dein#add('neovim/nvim-lspconfig')
" call dein#add('williamboman/mason.nvim')
" call dein#add('williamboman/mason-lspconfig.nvim')
" call dein#add('hrsh7th/nvim-cmp')
" call dein#add('hrsh7th/cmp-nvim-lsp')
" call dein#add('hrsh7th/cmp-buffer')
" call dein#add('hrsh7th/cmp-path')

" LSP設定の初期化（Lua設定へ移行推奨）
lua << EOF
-- Mason設定
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- 自動インストールする言語サーバー
require("mason-lspconfig").setup({
    ensure_installed = {
        "gopls",        -- Go
        "tsserver",     -- JavaScript/TypeScript
        "pyright",      -- Python
        "solargraph",   -- Ruby
        "html",         -- HTML
        "cssls",        -- CSS
        "jsonls",       -- JSON
    },
    automatic_installation = true,
})

-- LSP設定のセットアップ
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- 共通のキーマップ設定
local on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- 補完機能の設定
local capabilities = cmp_nvim_lsp.default_capabilities()

-- 各言語サーバーの設定
lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            gofumpt = true,
            analyses = {
                unusedparams = true,
                shadow = true,
            },
        },
    },
})

lspconfig.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
            },
        },
    },
})

lspconfig.solargraph.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- nvim-cmp設定
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
})

-- 診断設定
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

-- 診断のサイン設定
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
EOF

" LSP関連のキーマップ（Vimscript版）
nnoremap <silent> <space>e <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <space>q <cmd>lua vim.diagnostic.setloclist()<CR>

" LSP情報表示
command! LspInfo lua print(vim.inspect(vim.lsp.get_active_clients()))
command! LspInstallInfo Mason