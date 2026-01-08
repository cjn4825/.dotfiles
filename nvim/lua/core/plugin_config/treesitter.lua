-- require'nvim-treesitter'.install {
--     "vim",
--     "vimdoc",
--     "lua",
--     "python",
--     "json",
--     "yaml",
--     "dockerfile",
--     "bash",
--     "markdown",
--     "tmux",
--     "ini",
--     "terraform",
--     "gitignore",
--     "ssh_config"
-- }

require'nvim-treesitter'.setup {
    ensure_installed = {
        "vim",
        "vimdoc",
        "lua",
        "python",
        "json",
        "yaml",
        "dockerfile",
        "bash",
        "markdown",
        "tmux",
        "ini",
        "terraform",
        "gitignore",
        "ssh_config"
    },

    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
    },
}

-- require'nvim-treesitter.configs'.setup {
--     ensure_installed = {
--         "vim",
--         "vimdoc",
--         "lua",
--         "python",
--         "json",
--         "yaml",
--         "dockerfile",
--         "bash",
--         "markdown",
--         "tmux",
--         "ini",
--         "terraform",
--         "gitignore",
--         "ssh_config"
--     },
--     sync_install = false,
--     auto_install = true,
--     highlight = {
--         enable = true,
--     },
-- }

