return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
        local tools = require("core.tools")

        local function check(formatters_name)
            for _, item in ipairs(tools.linters_to_install) do
                if item == formatters_name then
                    return true
                end
            end
            return false
        end

		conform.setup({
			formatters_by_ft = { -- this is pretty ugly but works for now
                lua = check("lauformatter") and { "luaformatter" } or {},
                sh = check("beautysh") and { "beautysh" } or {},
                bash = check("beautysh") and { "beautysh" } or {},
                python = check("black") and { "black" } or {},
                terraform = check("terraform") and { "terraform" } or {},
                javascript = check("prettier") and { "prettier" } or {},
                js = check("prettier") and { "prettier" } or {},
                yaml = check("prettier") and { "prettier" } or {},
                go = check("gofumpt") and { "gofumpt" } or {},
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
