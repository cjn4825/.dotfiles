-- -- Mason Setup
-- require("mason").setup()
-- require("mason-lspconfig").setup({
--     ensure_installed = {
--         "pyright",
--         "bashls",
--     },
--     -- Handlers tell mason-lspconfig what to do when a server is installed/available
--     handlers = {
--         -- Default handler to setup lspconfig for any listed server
--         function(server_name)
--             require("lspconfig")[server_name].setup({})
--         end,
--     },
-- })

-- -- keymaps for definitions, implementations, and language references
-- local opts = { noremap = true, silent = true }
-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
-- vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

-- -- Diagnostic Highlighting in gruvbox theme
-- vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" }) -- Red for errors
-- vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" }) -- Yellow for warnings
-- vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" }) -- Blue for info
-- vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" }) -- Aqua for hints

-- -- General Diagnostic Config
-- vim.diagnostic.config({
--     virtual_text = true,
--     signs = false,
--     underline = true,
--     update_in_insert = true,
--     severity_sort = true,
-- })

-- -- Floating Window Styling
-- vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
-- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

-- -- CMP Setup
-- local cmp = require("cmp")
-- cmp.setup({
--     sources = {
--         {
--             name = 'buffer',
--             option = {
--                 get_bufnrs = function()
--                     return vim.api.nvim_list_bufs()
--                 end
--             }
--         },
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--         { name = 'path' },
--     },
--     window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered(),
--     },
-- })

-- -- Snippet Loader
-- require("luasnip.loaders.from_vscode").lazy_load()

-- -- LSP Capabilities
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- -- LSP UI Handlers
-- local handlers = {
--     ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
-- }

-- vim.lsp.config("*", {
--   capabilities = capabilities,
--   handlers = handlers
-- })

-- windowed borders for everything lsp related
vim.o.winborder = "rounded"

local function apply_ui_fixes()
    local bordercolor = '#ebdbb2'

    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = bordercolor })
    vim.api.nvim_set_hl(0, 'CmpBorder', { fg = bordercolor })

    vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'CmpPmenu', { link = 'Normal' })

    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" })
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" })
    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" })
    vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" })
end

apply_ui_fixes()
vim.api.nvim_create_autocmd('ColorScheme', { pattern = '*', callback = apply_ui_fixes })

-- mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "bashls",
    },
    automatic_enable = true,
})

-- The Bridge: Apply completion capabilities to all servers globally
vim.lsp.config("*", {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)

vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover({ border = "rounded" })
end, opts)

-- general diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
})

-- cmp setup
local cmp = require("cmp")
cmp.setup({
    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder",
        }),
        documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder",
        }),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        {
            name = 'buffer',
            option = {
                get_bufnrs = function() return vim.api.nvim_list_bufs() end
            }
        },
    },
})

-- Snippet Loader
require("luasnip.loaders.from_vscode").lazy_load()

