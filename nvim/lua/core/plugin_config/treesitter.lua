return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
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
