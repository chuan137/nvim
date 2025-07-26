vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.lazyloading = true

local eval = require("utils").eval
vim.g.minimal = eval(os.getenv("NVIM_MINIMAL"))

require("deps")
