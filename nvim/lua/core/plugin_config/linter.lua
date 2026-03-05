return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
        local tools = require("core.tools")

        local function check(linter_name)
            for _, item in ipairs(tools.linters_to_install) do
                if item == linter_name then
                    return true
                end
            end
            return false
        end

        local selene = lint.linters.selene
        selene.args = {
            "--config",
            vim.fn.stdpath("config") .. "/selene.toml",
            "--display-style",
            "quiet",
            "-"
        }

		lint.linters_by_ft = {
			lua = check("selene") and { "selene" } or {},
			sh = check("shellcheck") and { "shellcheck" } or {},
			bash = check("shellcheck") and { "shellcheck" } or {},
			Dockerfile = check("hadolint") and { "hadolint" } or {},
			json = check("jsonlint") and { "jsonlint" } or {},
			yaml = check("yamllint") and { "yamllint" } or {},
			javascript = check("eslint_d") and { "eslint_d" } or {},
			js = check("eslint_d") and { "eslint_d" } or {},
			terraform = check("tflint") and { "tflint" } or {},
			python = check("bandit") and { "bandit" } or {},
			go = check("golangci-lint") and { "golangci-lint" } or {},
			php = check("phpstan") and { "phpstan" } or {},
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})

	end
}
