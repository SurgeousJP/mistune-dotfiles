-- map({mode}, {shortcut}, {command})
vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>e", ":Ex<CR>")
map("i", "<C-c>", "<Esc>")
map("v", "<C-c>", "<Esc>")
map("s", "<C-c>", "<Esc>")