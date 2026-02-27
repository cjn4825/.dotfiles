return {
	{
		"nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context"
        },
		build = ":TSUpdate",
        branch = "main",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter").setup({
				auto_install = true,
				sync_install = false,
				highlight = {
					enable = true,
				},
			})
		end,
	},
}
