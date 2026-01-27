return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local function apply_ui_fixes()
        local bordercolor = "#ebdbb2"
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = bordercolor })
        vim.api.nvim_set_hl(0, "CmpBorder", { fg = bordercolor })
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
        vim.api.nvim_set_hl(0, "CmpPmenu", { link = "Normal" })

        vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" })
        vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" })
        vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" })
        vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" })
      end

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      })

      apply_ui_fixes()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

    require("mason").setup()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            settings = { Lua = { diagnostics = { globals = { "vim" } } } },
          })
        end,
      }

      require("mason-lspconfig").setup({
        ensure_installed = {},
        handlers = handlers,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = "rounded" })
          end, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
}    --   vim.o.winborder = "rounded"

    --   local function apply_ui_fixes()
    --     local bordercolor = "#ebdbb2"

    --     vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = bordercolor })
    --     vim.api.nvim_set_hl(0, "CmpBorder", { fg = bordercolor })

    --     vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    --     vim.api.nvim_set_hl(0, "CmpPmenu", { link = "Normal" })

    --     vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" })
    --     vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = "#fabd2f" })
    --     vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = "#83a598" })
    --     vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = "#8ec07c" })
    --   end

    --   apply_ui_fixes()

    --   vim.api.nvim_create_autocmd("ColorScheme", {
    --     callback = apply_ui_fixes,
    --   })

    --   require("mason").setup()

    --   vim.diagnostic.config({
    --     virtual_text = true,
    --     signs = false,
    --     underline = true,
    --     update_in_insert = false,
    --     severity_sort = true,
    --     float = {
    --       border = "rounded",
    --       winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    --     },
    --   })

    --   vim.api.nvim_create_autocmd("LspAttach", {
    --     callback = function(event)
    --       local opts = { buffer = event.buf, silent = true }

    --       vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    --       vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

    --       vim.keymap.set("n", "gr",
    --         require("telescope.builtin").lsp_references,
    --         opts
    --       )

    --       vim.keymap.set("n", "K", function()
    --         vim.lsp.buf.hover({ border = "rounded" })
    --       end, opts)
    --     end,
    --   })

    --   vim.lsp.config("lua_ls", {
    --     settings = {
    --       Lua = {
    --         diagnostics = {
    --           globals = { "vim" },
    --         },
    --       },
    --     },
    --   })
    -- end,
  -- },
-- }

