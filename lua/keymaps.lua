local M = {}

local map = vim.keymap.set

-- stylua: ignore start
local i = function(...) map("i", ...) end
local n = function(...) map("n", ...) end
local x = function(...) map("x", ...) end
-- local function nn(lhs, rhs, opts) n(lhs, rhs, { noremap = true, desc = opts.desc or nil }) end
-- stylua: ignore end

-- =============================================================================
-- Global mappings
-- =============================================================================
i('jk', '<esc>', { desc = 'Escape' })

n('<Esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch' })
n('<C-s>', '<cmd>w<cr>', { desc = 'Save' })
n('J', 'mzJ`z', { desc = 'Join lines without moving cursor' })
n('Y', 'y$', { desc = 'Yank to end of line' })

-- Scroll up/down
n('<C-k>', '<C-y>k', { desc = 'Scroll up' })
n('<C-j>', '<C-e>j', { desc = 'Scroll down' })

-- delete/paste without yanking to the clipboard
n('<leader>d', '"_d', { desc = 'Delete without yanking' })
x('<leader>d', '"_d', { desc = 'Delete without yanking' })
x('<leader>p', '"_dP', { desc = 'Paste without yanking' })

-- register
n('g.', '`.', { desc = 'Jump to last edit' })

-- window
-- start all window keymaps with leader
n('<leader>w', '<c-w>', { desc = 'Window' })

-- minimize window
n('<leader>w0', '<cmd>vertical resize 1<cr>', { desc = 'minimize window vertically' })
n('<leader>w)', '<cmd>resize 1<cr>', { desc = 'minimize window' })

-- quit previous window; useful for closing quickfix or diff windows
n('<M-q>', '<cmd>wincmd p | q<cr>', { desc = 'Quit previous window' })

-- tab
-- n('<c-t>', '<cmd>tabnext<cr>', { desc = 'next tab' })

-- buffer
n('<leader><space>', '<C-^>', { desc = 'Switch to last buffer' })

n(']g', '<cmd>lua MiniDiff.goto_hunk("next")<cr>zz', { desc = 'MiniDiff: Next hunk' })
n('[g', '<cmd>lua MiniDiff.goto_hunk("prev")<cr>zz', { desc = 'MiniDiff: Previous hunk' })

-- diff
n('<leader>gd', '<cmd>Git diff<cr><cmd>only<cr>', { desc = 'Git diff' })
n('<leader>gx', '<cmd>DiffviewClose<cr>', { desc = 'Diffview close' })
n('<leader>gf', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Diffview file history' })

-- trouble
n('<leader>xx', '<cmd>TroubleToggle<cr>', { desc = 'Trouble' })
n('<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', { desc = 'Workspace diagnostics' })
n('<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', { desc = 'Document diagnostics' })
n('<leader>xl', '<cmd>TroubleToggle loclist<cr>', { desc = 'Location list' })
n('<leader>xq', '<cmd>TroubleToggle quickfix<cr>', { desc = 'Quickfix' })
-- n('gR', function() require("trouble").toggle("lsp_references") end, { desc = 'LSP references' })
-- n('<leader>xJ', function() require("trouble").open { mode = "jumps" } end, { desc = 'Jumps' })
-- stylua: ignore start
n(']x', function() require("trouble").next({ jump = true }) end, { desc = 'Next trouble' })
n('[x', function() require("trouble").previous({ jump = true }) end, { desc = 'Previous trouble' })
-- stylua: ignore end

n('<leader>;', ':', { desc = 'Command mode' })

-- =============================================================================
-- Plugin mappings
-- =============================================================================
M.any_jump = {
  { 'gj', '<cmd>AnyJump<cr>', desc = 'AnyJump' },
  { 'gh', '<cmd>AnyJumpBack<cr>', desc = 'AnyJumpBack' },
}

local function fzf_live_grep()
  -- require('fzf-lua').live_grep_glob {}
  require('fzf-lua').live_grep_glob({ cwd = require('lazyvim.util').root.get() })
end

local function fzf_find_files()
  -- require('fzf-lua').files {}
  require('fzf-lua').files({ cwd = require('lazyvim.util').root.get() })
end

local function fzf_grep_cword()
  require('fzf-lua').grep_cword({ cwd = require('lazyvim.util').root.get() })
end

local function fzf_old_files()
  -- Read from ShaDa to include files that were already deleted from the buffer list.
  vim.cmd('rshada!')
  require('fzf-lua').oldfiles()
end

local function fzf_live_grep_0()
  require('fzf-lua').live_grep({ cwd = vim.fn.expand('%:p:h') })
end

M.fzflua = {
  -- stylua: ignore start
  -- { '<F4>',    '<cmd>FzfLua lsp_code_actions<cr>',          desc = 'Code Actions' },
  { '<F1>',       '<cmd>FzfLua help_tags<cr>',             desc = 'Help tags' },
  { '<F2>',       '<cmd>FzfLua file_browser<cr>',          desc = 'File browser' },
  { '<c-n>',      '<cmd>FzfLua buffers<cr>',               desc = 'Find buffers' },
  { '<leader>.',  '<cmd>FzfLua resume<cr>',                desc = 'Resume last command' },
  { '<leader>e',  '<cmd>FzfLua grep_curbuf<cr>',           desc = 'Grep current buffer' },
  { '<leader>k',  '<cmd>FzfLua lsp_document_symbols<cr>',  desc = 'Document symbols' },
  { '<leader>K',  '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
  { '<leader>F',  '<cmd>FzfLua git_files<cr>',             desc = 'Git files' },
  { '<leader>gs', '<cmd>FzfLua git_status<cr>',            desc = 'Git status' },
  { '<leader>m',  '<cmd>FzfLua colorschemes<cr>',          desc = 'Colorschemes' },
  { '<leader>P',  '<cmd>FzfLua commands<cr>',              desc = 'Commands' },
  { '<leader>/',  fzf_live_grep,                           desc = 'Live grep (root)' },
  { '<leader>c',  fzf_grep_cword,                          desc = 'Grep current word (root)' },
  { '<leader>C',  fzf_live_grep_0,                         desc = 'Grep current word (pwd)' },
  { '<leader>f',  fzf_find_files,                          desc = 'Find files (root)' },
  { '<leader>p',  fzf_old_files,                           desc = 'Recently opened files' },
  -- { '<leader>x',  '<cmd>FzfLua lsp_document_diagnostics<cr>',  desc = 'Document diagnostics' },
  -- { '<leader>X',  '<cmd>FzfLua lsp_workspace_diagnostics<cr>', desc = 'Workspace diagnostics' },
}

M.gitsigns = {
  { '<leader>gb', '<cmd>Gitsigns blame_line<cr>', desc = 'Blame line' },
  { '<leader>go', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview hunk' },
  -- { ']g',         '<cmd>Gitsigns next_hunk<cr>',       desc = 'Next hunk' },
  -- { '[g',         '<cmd>Gitsigns prev_hunk<cr>',       desc = 'Previous hunk' },
  -- { '<leader>gh', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage hunk', mode = { 'n', 'v' } },
  -- { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo stage hunk', mode = { 'n', 'v' } },
}

M.neogit = {
  { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
}

M.whichkey = {
  g = { name = 'Git' },
  w = {
    name = 'Window',
    ['='] = 'balance window',
    ['-'] = 'decrease window height',
    ['+'] = 'increase window height',
    ['<'] = 'decrease window width',
    ['>'] = 'increase window width',
    ['_'] = 'maximize window',
    ['|'] = 'maximize window',
    c = 'close window',
    o = 'close other windows',
    s = 'split window',
    v = 'vsplit window',
    w = 'switch window',
    x = 'swap window',
    H = 'move window left',
    J = 'move window down',
    K = 'move window up',
    L = 'move window right',
  },
  x = { name = 'Trouble' },
}

M.oil = {
  { '<leader><cr>', function() require('oil').toggle_float() end, desc = 'Open Oil' },
}

return M
