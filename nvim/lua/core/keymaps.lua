vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
-- function ResizeOppositeSplit(direction)
--   local win = vim.api.nvim_get_current_win()
--   local cur_pos = vim.api.nvim_win_get_cursor(win) -- Save cursor position {row, col}

--   if direction == "left" then
--     vim.cmd("wincmd h")
--     if vim.api.nvim_get_current_win() ~= win then
--       vim.cmd("vertical resize -2")
--     else
--       vim.cmd("wincmd l | vertical resize +2")
--     end
--   elseif direction == "right" then
--     vim.cmd("wincmd l")
--     if vim.api.nvim_get_current_win() ~= win then
--       vim.cmd("vertical resize -2")
--     else
--       vim.cmd("wincmd h | vertical resize +2")
--     end
--   elseif direction == "up" then
--     vim.cmd("wincmd k")
--     if vim.api.nvim_get_current_win() ~= win then
--       vim.cmd("resize -2")
--     else
--       vim.cmd("wincmd j | resize +2")
--     end
--   elseif direction == "down" then
--     vim.cmd("wincmd j")
--     if vim.api.nvim_get_current_win() ~= win then
--       vim.cmd("resize -2")
--     else
--       vim.cmd("wincmd k | resize +2")
--     end
--   end

--   -- Restore cursor position
--   vim.api.nvim_set_current_win(win) -- Go back to the original window
--   vim.api.nvim_win_set_cursor(win, cur_pos) -- Restore cursor position
-- end

-- -- Map keys to call the function
-- vim.keymap.set("n", "<A-h>",  function() ResizeOppositeSplit("left") end,  { noremap = true, silent = true })
-- vim.keymap.set("n", "<A-l>", function() ResizeOppositeSplit("right") end, { noremap = true, silent = true })
-- vim.keymap.set("n", "<A-k>",    function() ResizeOppositeSplit("up") end,    { noremap = true, silent = true })
-- vim.keymap.set("n", "<A-j>",  function() ResizeOppositeSplit("down") end,  { noremap = true, silent = true })

vim.cmd [[
    set encoding=utf-8
    set ruler
    set nu
    set shm+=I
    set nohlsearch
    set noshowmode
    set signcolumn=yes
    set t_ut=
    set gcr=a:blinkon1

    let g:loaded_perl_provider = 0
    let g:loaded_node_provider = 0

    "" split screen vert and horizontal
    nnoremap <leader>v <cmd>vsplit<cr>
    nnoremap <leader>h <cmd>split<cr>

    set clipboard=unnamedplus

    set noswapfile

     "" Remember cursor position
 augroup vimrc-remember-cursor-position
     autocmd!
     autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
 augroup END
]]

-- auto indent going into insert mode in scope
vim.keymap.set('n', 'i', function ()
    return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i'
end, {expr=true, noremap=true})

