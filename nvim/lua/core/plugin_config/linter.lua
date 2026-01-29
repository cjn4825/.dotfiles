return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			Dockerfile = { "hadolint" },
			json = { "jsonlint" },
			yaml = { "yamllint" },
			javascript = { "eslint_d" },
			js = { "eslint_d" },
			terraform = { "tflint" },
			python = { "bandit" },
			lua = { "selene" },
			ansible = { "ansible-lint" }
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end)
	end,
}
