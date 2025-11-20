-- ~/.config/nvim/init.lua

-- 1. Carica le impostazioni di base e le mappature PRIMA di tutto.
require('core.options')
require('core.keymaps')

-- 2. Bootstrap per lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- L'ultima versione stabile
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Setup di Lazy con la nostra lista di plugin
-- (Dice a Lazy di caricare tutti i file in 'lua/plugins/')
require("lazy").setup("plugins")

