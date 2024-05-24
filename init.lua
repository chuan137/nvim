vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config')
require('options')
require('autocmds')
require('keymaps') -- load keymaps after plugins and commands
require('profile')

-- use base16 colorscheme after loading plugin mini-base16
vim.cmd.colorscheme('base16-cupertino-light')
-- vim.cmd.colorscheme('base16-decaf')
-- vim.cmd.colorscheme('base16-gruvbox-dark-medium')

-- vim: ts=2 sts=2 sw=2 et
