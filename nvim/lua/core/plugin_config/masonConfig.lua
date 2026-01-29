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
			local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
			vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

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
				signs = false,
				float = { border = "rounded" },
			})

			apply_ui_fixes()

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason").setup()

			local handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						single_file_support = true,
					})
				end,
                -- go through old commits to see why the global vim thing still happens
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						},
					})
				end,

				["ansiblels"] = function()
					require("lspconfig").ansiblels.setup({
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
				end,

				["terraformls"] = function()
					require("lspconfig").terraformls.setup({
						capabilities = capabilities,
					})
				end,

				["bashls"] = function()
					require("lspconfig").bashls.setup({
						capabilities = capabilities,
						filetypes = { "sh", "bash" },
						root_dir = require("lspconfig.util").find_git_ancestor() or vim.loop.cwd(),
					})
				end,

				["jsonls"] = function()
					require("lspconfig").jsonls.setup({
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,

				["yamlls"] = function()
					require("lspconfig").yamlls.setup({
						capabilities = capabilities,
						filetypes = { "yaml", "yaml.github", "yaml.docker-compose" },
						settings = {
							yaml = {
								schemaStore = { enable = false, url = "" },
								schemas = require("schemastore").yaml.schemas({
									select = {
										"GitHub Workflow",
										"GitHub Actions",
									},
								}),
								validate = true,
								completion = true,
								hover = true,
							},
						},
					})
				end,
			}

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"dockerls",
					"yamlls",
					"bashls",
					"jsonls",
					"pyright",
					"ansiblels",
					"terraformls",
				},
				handlers = handlers,
			})
            -- ansible lint not found?
			require("mason-tool-installer").setup({
				ensure_installed = {
					"shellcheck",
					"hadolint",
					"jsonlint",
					"yamllint",
					"tflint",
					"ansible-lint",
					"actionlint",
					"bandit",
					"selene",
					"beautysh",
					"black",
					"stylua",
				},
			})

			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = {
					"*/tasks/*.{yml,yaml}",
					"*/roles/*.{yml,yaml}",
					"site.{yml,yaml}",
					"playbook.{yml,yaml}",
					"main.{yml,yaml}",
				},
				callback = function()
					vim.bo.filetype = "yaml.ansible"
				end,
			})

			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = { "*/.github/workflows/*.{yml,yaml}" },
				callback = function()
					vim.bo.filetype = "yaml.github"
				end,
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
}
