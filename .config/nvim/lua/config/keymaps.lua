-- map({mode}, {shortcut}, {command})
vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>e", ":Ex<CR>")
map("i", "<C-c>", "<Esc>")
map("v", "<C-c>", "<Esc>")
map("s", "<C-c>", "<Esc>")
map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')

-- Delete a word backwards
map("n", "dw", 'vb"_d')

-- Select all
map("n", "<C-a>", "gg<S-v>G")

-- VsCode keybindings remap
map("n", "gI", vim.lsp.buf.implementation) -- Go to implementation (like Ctrl+F12 in VS Code)
map("n", "gr", vim.lsp.buf.references) -- Go to references (like Shift+F12 in VS Code)  
map("n", "ga", vim.lsp.buf.code_action) -- Quick action (like Ctrl+. in VS Code)
map("v", "ga", vim.lsp.buf.code_action) -- Quick action in visual mode