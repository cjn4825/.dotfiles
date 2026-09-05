return {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
                local ts = require("nvim-treesitter")
                ts.setup({})

                local parsers = {
                    "c", "lua", "bash", "python", "json", "yaml",
                    "dockerfile", "go", "javascript", "markdown",
                }

                ts.install(parsers)

                vim.api.nvim_create_autocmd("FileType", {
                    pattern = parsers,
                    callback = function()
                            vim.treesitter.start()
                    end,
                })
        end,
      },
}
