vim.opt.nu = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.cache/vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
-- vim.opt.clipboard = 'unnamedplus'
vim.opt.spelllang = "en_us"
vim.opt.spell = false
vim.opt.termguicolors = true

-- Use :set list to view the spaces
vim.o.listchars = 'tab:·┈,trail:￮,multispace:￮,lead: ,extends:▶,precedes:◀,nbsp:‿'

-- Neovide
if vim.g.neovide then
    vim.o.guifont = "JetBrains Mono Nerd Font:h14"
    vim.g.neovide_cursor_vfx_mode = "railgun"
end
