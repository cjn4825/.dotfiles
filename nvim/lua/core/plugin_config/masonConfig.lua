return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/SchemaStore.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()

			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				signs = false,
				float = { border = "rounded" },
			})

            local bordercolor = "#ebdbb2"

            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = bordercolor })
            vim.api.nvim_set_hl(0, "CmpBorder", { fg = bordercolor })
            vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
            vim.api.nvim_set_hl(0, "CmpPmenu", { link = "Normal" })
            vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" })
            vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" })
            vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" })
            vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" })

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            })

            vim.lsp.config("ansiblels", {
                capabilities = capabilities,
                filetypes = { "ansible", "yaml.ansible" },
                settings = {
                    ansible = {
                        validation = {
                            enabled = true,
                            lint = { enabled = true, path = "ansible-lint" },
                        },
                    },
                },
            })

            vim.lsp.config("terraformls",{
                capabilities = capabilities,
            })

            vim.lsp.config("pyright",{
                capabilities = capabilities,
            })

            vim.lsp.config("gopls",{
                capabilities = capabilities,
            })

            vim.lsp.config("bashls", {
                capabilities = capabilities,
                filetypes = { "sh", "bash" },
                root_dir = require("lspconfig.util").find_git_ancestor() or vim.loop.cwd(),
            })

            vim.lsp.config("jsonls", {
                capabilities = capabilities,
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            })

            vim.lsp.config("yamlls", {
                capabilities = capabilities,
                filetypes = { "yaml", "yaml.github", "yaml.docker-compose" },
                settings = {
                    yaml = {
                        schemaStore = { enable = false, url = "" },
                        schemas = require("schemastore").yaml.schemas({
                            -- select = {
                            --     "GitHub Workflow",
                            --     "GitHub Actions",
                            -- },
                        }),
                        validate = true,
                        completion = true,
                        hover = true,
                    },
                },
            })

			require("mason").setup()

            local tools = require("core.tools")

			require("mason-lspconfig").setup({
				ensure_installed = tools.lsp_to_install,
			})

			require("mason-tool-installer").setup({
				ensure_installed = tools.all_tools
			})

			-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			-- 	pattern = {
			-- 		"*/tasks/*.{yml,yaml}",
			-- 		"*/roles/*.{yml,yaml}",
			-- 		"site.{yml,yaml}",
			-- 		"playbook.{yml,yaml}",
			-- 		"main.{yml,yaml}",
			-- 	},
			-- 	callback = function()
			-- 		vim.bo.filetype = "yaml.ansible"
			-- 	end,
			-- })

			-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			-- 	pattern = { "*/.github/workflows/*.{yml,yaml}" },
			-- 	callback = function()
			-- 		vim.bo.filetype = "yaml.github"
			-- 	end,
			-- })

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
}
