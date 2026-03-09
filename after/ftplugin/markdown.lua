vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = true

vim.opt_local.spell = true
vim.opt_local.linebreak = true
vim.opt_local.showbreak = "  ↪ "
vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt_local.foldlevel = 1

vim.o.textwidth = 120
