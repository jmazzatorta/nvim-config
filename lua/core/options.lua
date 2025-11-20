-- ~/.config/nvim/lua/core/options.lua

local opt = vim.opt 

-- General settings

opt.encoding = "utf-8"              -- Codifica UTF-8
opt.history = 200                   -- Aumenta cronologia comandi
opt.autoread = true                 -- Ricarica file modificati all'esterno

opt.hidden = true                   -- Nascondi buffer senza salvarlo
opt.swapfile = false                -- No file .swp
opt.backup = false                  -- No file ~
opt.writebackup = false             -- No backup durante la scrittura

opt.clipboard = "unnamedplus"       -- Usa appunti di sistema

-- User Interface
opt.number = true                   -- Mostra numeri di riga
opt.termguicolors = true            -- Abilita colori a 24-bit 
opt.scrolloff = 8                   -- 8 righe di contesto sopra/sotto il cursore
opt.cmdheight = 1                   -- Altezza linea di comando
opt.showmatch = true                -- Evidenzia parentesi corrispondenti
opt.splitright = true               -- Split verticali a destra
opt.splitbelow = true               -- Split orizzontali in basso

-- Formatting
opt.tabstop = 4                     -- Spazi per un TAB
opt.softtabstop = 4                 -- Spazi per TAB durante la modifica
opt.shiftwidth = 4                  -- Spazi per autoindentazione
opt.expandtab = true                -- Usa spazi al posto dei TAB
opt.autoindent = true               -- Indenta automaticamente

-- Research
opt.incsearch = true                -- Ricerca incrementale
opt.hlsearch = true                 -- Evidenzia risultati
opt.ignorecase = true               -- Ignora maiuscole/minuscole
opt.smartcase = true                -- ...a meno che non ci sia una maiuscola
