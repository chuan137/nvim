local M = {}

-- =============================================================================
-- Global mappings
-- =============================================================================
-- stylua: ignore start
local i = function(...) vim.keymap.set("i", ...) end
local n = function(...) vim.keymap.set("n", ...) end
local x = function(...) vim.keymap.set("x", ...) end
-- stylua: ignore end

n('<F1>', 'FzfLua help_tags', { desc = 'Help tags' })
n('<Esc>', '<cmd>noh<cr><esc>', { desc = 'Clear hlsearch' })
n("<leader><tab>", "<C-^>", { desc = "Switch to last buffer" })
-- n("g<space>", "<C-^>", { desc = "Switch to last buffer" })

n('Y', 'y$', { desc = 'Yank to end of line' })
n('n', 'nzzzv', { desc = 'Center line after search' })
n('N', 'Nzzzv', { desc = 'Center line before search' })
n('J', 'mzJ`z', { desc = 'Join lines without moving cursor' })

i('<C-j>', '<esc>', { desc = 'Escape' })

-- quit previous window; useful for closing quickfix or diff windows
n('<M-q>', '<cmd>wincmd p | q<cr>', { desc = 'Quit previous window' })

-- delete/paste without yanking to the clipboard
n('<leader>d', '"_d', { desc = 'Delete without yanking' })
x('<leader>d', '"_d', { desc = 'Delete without yanking' })
x('<leader>p', '"_dP', { desc = 'Paste without yanking' })

-- lsp
n('[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { desc = 'Previous diagnostic' })
n(']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { desc = 'Next diagnostic' })

-- open diagnostics float
n('<leader>xl', '<cmd>lua require("lsp").open_diagnostics()<cr>', { desc = 'Open diagnostics' })

-- n(';', ':', { desc = 'Command' })
-- map('n', '<leader>xl', '<cmd>lua require("lsp").toggle_line_diagnostics()<cr>', { desc = 'Toggle line diagnostics' })
-- map('n', '<leader>xl', '<cmd>lua require("lsp").toggle_virtual_text()<cr>', { desc = 'Toggle virtual text' })
-- map('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })
-- map('n', '<leader>lc', '<cmd>CmpStatus<cr>', { desc = 'Cmp status' })

-- =============================================================================
-- Plugin mappings
-- =============================================================================
M.fzflua = {
  { '<F4>', '<cmd>FzfLua lsp_code_actions<cr>', desc = 'Code Actions' },
  { '<c-p>', '<cmd>FzfLua resume<cr>', desc = 'Resume last command' },
  { '<leader>/', '<cmd>FzfLua live_grep_glob<cr>', desc = 'Live grep' },
  { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'Find buffers' },
  { '<leader>fc', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep current word' },
  { '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>', desc = 'Document diagnostics' },
  { '<leader>fD', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', desc = 'Workspace diagnostics' },
  { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
  { '<leader>fk', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document symbols' },
  { '<leader>fK', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
  { '<leader>fp', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
  {
    '<leader>fr',
    function()
      -- Read from ShaDa to include files that were already deleted from the buffer list.
      vim.cmd('rshada!')
      require('fzf-lua').oldfiles()
    end,
    desc = 'Recently opened files',
  },
  { '<leader>fz', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Grep current buffer' },
}

M.whichkey = {
  ['f'] = { name = 'Find' },
  ['g'] = { name = 'Git' },
  -- ["/"] = { "<Cmd>Telescope live_grep<CR>", "which_key_ignore" },
}

return M
