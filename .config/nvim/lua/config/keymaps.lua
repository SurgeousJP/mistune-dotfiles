-- map({mode}, {shortcut}, {command})
vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>e", ":Ex<CR>")

-- Map Esc to Ctrl-c in insert, visual, and select modes
map("i", "<C-c>", "<Esc>")
map("v", "<C-c>", "<Esc>")
map("s", "<C-c>", "<Esc>")

-- Map saved clipboard yank
map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')

-- Delete a word backwards
map("n", "dw", 'vb"_d')

-- Select all
map("n", "<C-a>", "gg<S-v>G")

-- VSCode specific keymaps
if vim.g.vscode then
  -- Navigation keymaps
  map("n", "gm", function() require("vscode").action("editor.action.goToImplementation") end, { silent = true })
  map("n", "gr", function() require("vscode").action("editor.action.goToReferences") end, { silent = true })
  map("n", "<leader>n", function() require("vscode").action("workbench.action.previousEditor") end, { silent = true })
  map("n", "<leader>m", function() require("vscode").action("workbench.action.nextEditor") end, { silent = true })
  map("n", "<leader>w", function() require("vscode").action("workbench.action.closeActiveEditor") end, { silent = true })
  map("n", "<C-m><C-o>", function() require("vscode").action("editor.foldAll") end, { silent = true })
  map("n", "<C-m><C-u>", function() require("vscode").action("editor.unfoldAll") end, { silent = true })
  map("n", "gp", function() require("vscode").action("editor.action.showHover") end, { silent = true })
end