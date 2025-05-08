-- Path for lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.cmd("set number")
require("vim-options")
require("lazy").setup("plugins")
vim.opt.termguicolors = true
vim.opt.number         = true
vim.opt.relativenumber = true
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true})
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true})
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true})
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true})
