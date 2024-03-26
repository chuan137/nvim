vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.hlsearch = false
vim.o.mouse = 'a'
vim.o.undofile = true		-- Save undo history
vim.o.breakindent = true

vim.wo.number = true		-- Make line numbers default
vim.wo.signcolumn = 'yes'	-- Keep signcolumn on by default
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Popup menu transparency
--   0: fully opaque
--   100: fully transparent
vim.opt.pumblend = 0

