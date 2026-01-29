return {
	{
		"ntpeters/vim-better-whitespace",
		event = "BufReadPost",
		init = function()
			vim.g.better_whitespace_enabled = 1
			vim.g.strip_whitespace_on_save = 1
		end,
		config = function()
			vim.cmd("highlight ExtraWhitespace guibg=#cc241d")
		end,
	},
}
