local M = {}

local map = vim.keymap.set

-- stylua: ignore start
local i = function(...) map("i", ...) end
local n = function(...) map("n", ...) end
local x = function(...) map("x", ...) end
local function nn(lhs, rhs, desc) n(lhs, rhs, { noremap = true, desc = desc }) end
-- stylua: ignore end

-- =============================================================================
-- Global mappings
-- =============================================================================
i('jk', '<esc>', { desc = 'Escape' })
i('<C-j>', '<esc>', { desc = 'Escape' })

n('<Esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch' })
n('<leader><tab>', '<C-^>', { desc = 'Switch to last buffer' })
n('<leader>w', '<c-w>', { desc = 'Window' })

n('Y', 'y$', { desc = 'Yank to end of line' })
n('n', 'nzzzv', { desc = 'Center line after search' })
n('N', 'Nzzzv', { desc = 'Center line before search' })
n('J', 'mzJ`z', { desc = 'Join lines without moving cursor' })
-- n('J', 'J$', { desc = '' }) -- go to end after a join
-- n('S', 'T hr<CR>k$', { desc = '' }) -- split (opposite of J)

-- Scroll up/down
n('<C-y>', '<C-y>k', { desc = 'Scroll up' })
n('<C-e>', '<C-e>j', { desc = 'Scroll down' })
n('<C-k>', '<C-y>k', { desc = 'Scroll up' })
n('<C-j>', '<C-e>j', { desc = 'Scroll down' })

-- quit previous window; useful for closing quickfix or diff windows
n('<M-q>', '<cmd>wincmd p | q<cr>', { desc = 'Quit previous window' })

-- delete/paste without yanking to the clipboard
n('<leader>d', '"_d', { desc = 'Delete without yanking' })
x('<leader>d', '"_d', { desc = 'Delete without yanking' })
x('<leader>p', '"_dP', { desc = 'Paste without yanking' })

-- register
n('gl', '`.', { desc = 'Jump to last edit' })

-- trouble
-- stylua: ignore start
n('<leader>xx', function() require("trouble").toggle() end, { desc = 'Trouble' })
n('<leader>xw', function() require("trouble").toggle("workspace_diagnostics") end, { desc = 'Workspace diagnostics' })
n('<leader>xd', function() require("trouble").toggle("document_diagnostics") end, { desc = 'Document diagnostics' })
n('<leader>xq', function() require("trouble").toggle("quickfix") end, { desc = 'Quickfix' })
n('<leader>xl', function() require("trouble").toggle("loclist") end, { desc = 'Location list' })
-- n('gR', function() require("trouble").toggle("lsp_references") end, { desc = 'LSP references' })
-- n('<leader>xJ', function() require("trouble").open { mode = "jumps" } end, { desc = 'Jumps' })
-- n(']x', function() require("trouble").next({ jump = true }) end, { desc = 'Next trouble' })
-- n('[x', function() require("trouble").previous({ jump = true }) end, { desc = 'Previous trouble' })
-- stylua: ignore end

-- window
-- minimize window
n('<leader>w0', '<cmd>vertical resize 1<cr>', { desc = 'minimize window vertically' })
n('<leader>w)', '<cmd>resize 1<cr>', { desc = 'minimize window' })

-- buffer
nn('<leader>b', ':b<space>', { desc = 'Switch buffer' })

-- =============================================================================
-- Plugin mappings
-- =============================================================================
M.any_jump = {
  { 'gj', '<cmd>AnyJump<cr>',     desc = 'AnyJump' },
  { 'gh', '<cmd>AnyJumpBack<cr>', desc = 'AnyJumpBack' },
}

local function fzf_live_grep()
  -- require('fzf-lua').live_grep_glob {}
  require('fzf-lua').live_grep_glob { cwd = require('lazyvim.util').root.get() }
end

local function fzf_find_files()
  -- require('fzf-lua').files {}
  require('fzf-lua').files { cwd = require('lazyvim.util').root.get() }
end

local function fzf_grep_cword()
  require('fzf-lua').grep_cword { cwd = require('lazyvim.util').root.get() }
end

M.fzflua = {
  { '<F1>',       '<cmd>FzfLua helptags<cr>',                  desc = 'Help tags' },
  -- { '<F4>',       '<cmd>FzfLua lsp_code_actions<cr>',          desc = 'Code Actions' },
  { '<leader>/',  fzf_live_grep,                               desc = 'Live grep (root)' },
  { '<leader>f.', '<cmd>FzfLua resume<cr>',                    desc = 'Resume last command' },
  { '<leader>fb', '<cmd>FzfLua buffers<cr>',                   desc = 'Find buffers' },
  { '<leader>fc', fzf_grep_cword,                              desc = 'Grep current word (root)' },
  { '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>',  desc = 'Document diagnostics' },
  { '<leader>fD', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', desc = 'Workspace diagnostics' },
  { '<leader>ff', fzf_find_files,                              desc = 'Find files (root)', },
  { '<leader>fg', '<cmd>FzfLua git_files<cr>',                 desc = 'Git files' },
  { '<leader>fk', '<cmd>FzfLua lsp_document_symbols<cr>',      desc = 'Document symbols' },
  { '<leader>fK', '<cmd>FzfLua lsp_workspace_symbols<cr>',     desc = 'Workspace symbols' },
  { '<leader>fp', '<cmd>FzfLua commands<cr>',                  desc = 'Commands' },
  {
    '<leader>fo',
    function()
      -- Read from ShaDa to include files that were already deleted from the buffer list.
      vim.cmd('rshada!')
      require('fzf-lua').oldfiles()
    end,
    desc = 'Recently opened files',
  },
  { '<leader>fv', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Grep current buffer' },
  { '<leader>fx', '<cmd>FzfLua grep_cword<cr>',  desc = 'Grep current word' },
}

M.gitsigns = {
  { ']g',         '<cmd>Gitsigns next_hunk<cr>',       desc = 'Next hunk' },
  { '[g',         '<cmd>Gitsigns prev_hunk<cr>',       desc = 'Previous hunk' },
  { '<leader>gh', '<cmd>Gitsigns stage_hunk<cr>',      desc = 'Stage hunk',      mode = { 'n', 'v' } },
  { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo stage hunk', mode = { 'n', 'v' } },
  { '<leader>gb', '<cmd>Gitsigns blame_line<cr>',      desc = 'Blame line' },
  { '<leader>go', '<cmd>Gitsigns preview_hunk<cr>',    desc = 'Preview hunk' },
}

M.neogit = {
  { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
}

M.whichkey = {
  f = { name = 'FzfLua' },
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

return M
