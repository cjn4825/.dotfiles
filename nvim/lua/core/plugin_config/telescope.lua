return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"<leader>f",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files from home",
			},
			{
				"<leader>g",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Grep files from home",
			},
			{
				"<leader>r",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "Recent files",
			},
			{
				"<leader>b",
				"<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
				desc = "File browser (cwd)",
			},
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				pickers = {
					find_files = {
						hidden = true,
                        search_dirs = {"~", "/workspaces/"}
					},
					live_grep = {
						additional_args = { "--hidden" },
                        search_dirs = {"~", "/workspaces/"}
					},
				},
				extensions = {
					file_browser = {
						auto_depth = true,
						display_stat = false,
						grouped = true,
						hide_parent_dir = false,
						select_buffer = true,
						hidden = true,
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
		end,
	},
}
