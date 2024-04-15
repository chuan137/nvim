local fn = vim.fn
local o = vim.o
local opt = vim.opt

opt.mouse = 'a'

opt.conceallevel = 0
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.pumblend = 12

opt.number = true
opt.numberwidth = 1
opt.relativenumber = true

-- Decrease update time
opt.timeout = true
opt.timeoutlen = 300
opt.updatetime = 250

-- Movement
opt.scrolloff = 3
opt.whichwrap = o.whichwrap .. '<,>,h,l'

-- Status
opt.showmode = false
opt.showcmd = false
opt.showtabline = 0

-- Indentation
opt.expandtab = true
opt.smarttab = true
opt.smartindent = true
-- opt.shiftwidth = 2
-- opt.softtabstop = 2
-- opt.tabstop = 2
opt.linebreak = true
opt.showbreak = string.rep(' ', 3)
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.wildmenu = true
opt.wildmode = 'longest:full,full'
opt.wildoptions = 'pum'

-- Editing
opt.modelines = 1
opt.breakindent = true
opt.showmatch = true
opt.swapfile = false
opt.undodir = fn.stdpath('data') .. '/undodir'
opt.undofile = true
opt.textwidth = 80
opt.wrap = true
opt.inccommand = 'split'
opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'hiddenoff',
  'algorithm:minimal',
}

opt.clipboard = 'unnamedplus'
opt.formatoptions = opt.formatoptions
  - 't' -- wrap with text width
  + 'c' -- wrap comments
  - 'r' -- insert comment after enter
  - 'o' -- insert comment after o/O
  - 'q' -- allow formatting of comments with gq
  - 'a' -- format paragraphs
  + 'n' -- recognized numbered lists
  - '2' -- use indent of second line for paragraph
  + 'l' -- long lines are not broken
  + 'j' -- remove comment when joining lines
opt.syntax = 'off'
opt.spell = false

-- Colors
opt.termguicolors = true

-- Shada
opt.shada = "!,'1000,f1,<1000,s100,:1000,/1000,h"

-- Sessions
-- opt.sessionoptions = "buffers,curdir,folds,help,winsize,winpos"

-- UI

-- Set grep program to rg
opt.grepprg = 'rg --vimgrep --smart-case'
opt.grepformat = '%f:%l:%c:%m'
