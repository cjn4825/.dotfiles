return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "luaformatter" },
				json = { "prettier" },
				yaml = { "prettier" },
				bash = { "beautysh" },
				asm = { "asmfmt" },
				python = { "black" },
				terraform = { "terraform" },
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			conform.format({
				lsp_fallback = true,
				aync = false,
				timeout_ms = 500,
			})
		end)
	end,
}
