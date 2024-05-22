local o = vim.o
local opt = vim.opt

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.syntax = 'off'
opt.swapfile = false
opt.textwidth = 80

-- Decrease timeout and update time
opt.timeout = true
opt.timeoutlen = 300
opt.updatetime = 500

-- Movement
opt.whichwrap = o.whichwrap .. '<,>,h,l'

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.wildmenu = true
opt.wildmode = 'longest:full,full'
opt.wildoptions = 'pum'

-- Editing
opt.breakindent = true
opt.showmatch = true
opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'hiddenoff',
  'algorithm:minimal',
}
-- opt.modelines = 1
-- opt.inccommand = 'split'

opt.clipboard = 'unnamedplus'
opt.formatoptions = 'jcroqlnt' -- tcqj
-- opt.formatoptions = opt.formatoptions
--   - 't' -- wrap with text width
--   + 'c' -- wrap comments
--   - 'r' -- insert comment after enter
--   - 'o' -- insert comment after o/O
--   - 'q' -- allow formatting of comments with gq
--   - 'a' -- format paragraphs
--   + 'n' -- recognized numbered lists
--   - '2' -- use indent of second line for paragraph
--   + 'l' -- long lines are not broken
--   + 'j' -- remove comment when joining lines

-- Shada
opt.shada = "!,'1000,f1,<1000,s100,:1000,/1000,h"

-- Sessions
-- opt.sessionoptions = "buffers,curdir,folds,help,winsize,winpos"

-- UI
opt.pumblend = 15
opt.scrolloff = 5 -- Lines of context at the top and bottom of the screen
opt.showtabline = 1
opt.termguicolors = true

-- wrap long lines
opt.linebreak = true
opt.showbreak = string.rep(' ', 3)
opt.breakindent = true
opt.wrap = true

-- Set grep program to rg
opt.grepprg = 'rg --vimgrep --smart-case'
opt.grepformat = '%f:%l:%c:%m'
