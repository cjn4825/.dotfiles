return {
	{
		"morhetz/gruvbox",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme gruvbox")
			vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3c3836" })
		end,
	},
}
