-- Enable the built-in module loader for faster startup (Neovim 0.9+)
if vim.loader then
    vim.loader.enable()
end

-- local eval = require("utils").eval
-- vim.g.minimal = eval(os.getenv("NVIM_MINIMAL"))

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.lazyloading = true

require("options")
require("keymaps")
require("autocmds")
require("deps")
