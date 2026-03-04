vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt
opt.guicursor = "n-v-c-i:block"
opt.backspace = "2"
opt.showcmd = true
opt.laststatus = 3
opt.autowrite = true
opt.autoread = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true
opt.termguicolors = true
opt.number = true
opt.ruler = true
opt.shortmess:append("I")
opt.hlsearch = false
opt.showmode = false
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.swapfile = false

local keymap = vim.keymap
keymap.set("n", "<leader>v", "<cmd>vsplit<cr>")
keymap.set("n", "<leader>h", "<cmd>split<cr>")

keymap.set("n", "i", function()
    return string.match(vim.api.nvim_get_current_line(), "%g") == nil and "cc" or "i"
end, { expr = true })

vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "Remember cursor position",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

local function highlight_whitespace()
    local ignore_fts = { "mason", "Lazy", "checkhealth" }
    local ignore_bts = { "terminal", "nofile", "prompt" }

    if vim.tbl_contains(ignore_fts, vim.bo.filetype) or
        vim.tbl_contains(ignore_bts, vim.bo.buftype) then
        return
    end

    pcall(vim.fn.matchdelete, 10)
    vim.fn.matchadd("TrailingWhitespace", [[\s\+$]], 11, 10)
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
    callback = highlight_whitespace
})

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        pcall(vim.fn.matchdelete, 10)
    end,
})
