-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


vim.keymap.set('n', '<C-w>', ':xa<CR>')
vim.keymap.set('n', '<C-s>', ':wa<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-q>', ':Ex<CR>')
