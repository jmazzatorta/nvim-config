-- ~/.config/nvim/lua/core/keymaps.lua

vim.g.mapleader = " "

local map = vim.keymap.set 

-- --- Globals keymaps ---

-- Windows navigation
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Vai a finestra Sinistra" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Vai a finestra Sotto" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Vai a finestra Sopra" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Vai a finestra Destra" })

-- Save file
map("n", "<leader>s", ":w<CR>", { silent = true, desc = "Salva file" })

-- Remove research highlight
map("n", "<esc>", ":noh<CR><esc>", { silent = true, desc = "Cancella evidenziazione ricerca" })


