local M = {}

-- stylua: ignore start
local i = function(...) vim.keymap.set("i", ...) end
local n = function(...) vim.keymap.set("n", ...) end
local x = function(...) vim.keymap.set("x", ...) end
-- stylua: ignore end

-- =============================================================================
-- Global mappings
-- =============================================================================
i('jk', '<esc>', { desc = 'Escape' })
i('<C-j>', '<esc>', { desc = 'Escape' })

n('<Esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch' })
n('<leader><tab>', '<C-^>', { desc = 'Switch to last buffer' })

n('Y', 'y$', { desc = 'Yank to end of line' })
n('n', 'nzzzv', { desc = 'Center line after search' })
n('N', 'Nzzzv', { desc = 'Center line before search' })
n('J', 'mzJ`z', { desc = 'Join lines without moving cursor' })
-- n('J', 'J$', { desc = '' }) -- go to end after a join
-- n('S', 'T hr<CR>k$', { desc = '' }) -- split (opposite of J)

-- Scroll up/down
n('<C-y>', '<C-y>k', { desc = 'Scroll up' })
n('<C-e>', '<C-e>j', { desc = 'Scroll down' })

-- quit previous window; useful for closing quickfix or diff windows
n('<M-q>', '<cmd>wincmd p | q<cr>', { desc = 'Quit previous window' })

-- delete/paste without yanking to the clipboard
n('<leader>d', '"_d', { desc = 'Delete without yanking' })
x('<leader>d', '"_d', { desc = 'Delete without yanking' })
x('<leader>p', '"_dP', { desc = 'Paste without yanking' })

-- lsp
n('[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { desc = 'Previous diagnostic' })
n(']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { desc = 'Next diagnostic' })
-- n('<leader>x', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<cr>', { desc = 'Open diagnostics' })
-- n('<leader>q', '<cmd>lua vim.diagnostic.setqflist()<cr>', { desc = 'Set quickfix list' })
-- n('<leader>Q', '<cmd>lua vim.diagnostic.setloclist()<cr>', { desc = 'Set location list' })
-- n(']q', '<cmd>cnext<cr>', { desc = 'Next quickfix' })
-- n('[q', '<cmd>cprev<cr>', { desc = 'Previous quickfix' })
   
-- window
n('<leader>w', '<c-w>', { desc = 'Window' })

-- trouble
n('<leader>xx', function() require("trouble").toggle() end, { desc = 'Trouble' })
n('<leader>xw', function() require("trouble").toggle("workspace_diagnostics") end, { desc = 'Workspace diagnostics' })
n('<leader>xd', function() require("trouble").toggle("document_diagnostics") end, { desc = 'Document diagnostics' })
n('<leader>xq', function() require("trouble").toggle("quickfix") end, { desc = 'Quickfix' })
n('<leader>xl', function() require("trouble").toggle("loclist") end, { desc = 'Location list' })
-- n('gR', function() require("trouble").toggle("lsp_references") end, { desc = 'LSP references' })
-- n('<leader>xJ', function() require("trouble").open { mode = "jumps" } end, { desc = 'Jumps' })
-- n(']x', function() require("trouble").next({ jump = true }) end, { desc = 'Next trouble' })
-- n('[x', function() require("trouble").previous({ jump = true }) end, { desc = 'Previous trouble' })

   
-- =============================================================================
-- Plugin mappings
-- =============================================================================
M.any_jump = {
  { 'gl', '<cmd>AnyJump<cr>', desc = 'AnyJump' },
  { 'gh', '<cmd>AnyJumpBack<cr>', desc = 'AnyJumpBack' },
}

M.fzflua = {
  { '<F1>', '<cmd>FzfLua helptags<cr>', desc = 'Help tags' },
  { '<F4>', '<cmd>FzfLua lsp_code_actions<cr>', desc = 'Code Actions' },
  -- { '<leader>/', '<cmd>FzfLua live_grep_glob<cr>', desc = 'Live grep' },
  {
    '<leader>/',
    '<cmd>lua require("fzf-lua").live_grep_glob { cwd = require("lazyvim.util").root.get() }<cr>',
    desc = 'Live grep',
  },

  { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'Find buffers' },
  { '<leader>fc', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep current word' },
  { '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>', desc = 'Document diagnostics' },
  { '<leader>fD', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', desc = 'Workspace diagnostics' },
  -- { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
  {
    '<leader>ff',
    '<cmd>lua require("fzf-lua").files({ cwd = require("lazyvim.util").root.get() })<cr>',
    desc = 'Find files',
  },

  { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = 'Git files' },
  { '<leader>fk', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document symbols' },
  { '<leader>fK', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
  { '<leader>fp', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
  {
    '<leader>fo',
    function()
      -- Read from ShaDa to include files that were already deleted from the buffer list.
      vim.cmd('rshada!')
      require('fzf-lua').oldfiles()
    end,
    desc = 'Recently opened files',
  },
  {
    '<leader>fw',
    '<cmd>lua require("fzf-lua").grep_cword { cwd = require("lazyvim.util").root.get() }<cr>',
    desc = 'Grep current word',
  },
  { '<leader>fx', '<cmd>FzfLua resume<cr>', desc = 'Resume last command' },
  { '<leader>fz', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Grep current buffer' },
}

M.gitsigns = {
  { ']g', '<cmd>Gitsigns next_hunk<cr>', desc = 'Next hunk' },
  { '[g', '<cmd>Gitsigns prev_hunk<cr>', desc = 'Previous hunk' },
  { '<leader>gh', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage hunk', mode = { 'n', 'v' } },
  { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo stage hunk', mode = { 'n', 'v' } },
  { '<leader>gb', '<cmd>Gitsigns blame_line<cr>', desc = 'Blame line' },
  { '<leader>gg', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview hunk' },
}

M.neogit = {
  { '<leader>go', '<cmd>Neogit<cr>', desc = 'Neogit' },
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
