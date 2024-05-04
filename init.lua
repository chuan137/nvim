vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.lazy')
require('config.options')
require('config.autocmds')

-- load keymaps after plugins and commands
require('config.keymaps')

-- vim: ts=2 sts=2 sw=2 et
