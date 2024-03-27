local M = {}

-- =============================================================================
-- Global mappings
-- =============================================================================
M.setup = function()
  -- quit previous window; useful for closing quickfix or diff windows
  vim.keymap.set('n', '<M-q>', '<cmd>wincmd p | q<cr>', { desc = 'Quit previous window' })

  -- delete/paste without yanking to the clipboard
  vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d')
  vim.keymap.set('x', '<leader>p', '"_dP')

  vim.keymap.set('n', '<leader><space>', '<cmd>e#<cr>', { desc = 'Switch to last file' })

  -- Clear search with <esc>
  vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

  -- vim.keymap.set('n', '<leader>xl', '<cmd>lua require("lsp").toggle_line_diagnostics()<cr>', { desc = 'Toggle line diagnostics' })
  -- vim.keymap.set('n', '<leader>xl', '<cmd>lua require("lsp").toggle_virtual_text()<cr>', { desc = 'Toggle virtual text' })
  vim.keymap.set('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'Open Lazy' })
  vim.keymap.set('n', '<leader>lc', '<cmd>CmpStatus<cr>', { desc = 'Open Lazy' })
end

-- =============================================================================
-- Plugin mappings
-- =============================================================================
M.fzflua = {
  { '<F4>', '<cmd>FzfLua lsp_code_actions<cr>', desc = 'Code Actions' },
  { '<c-p>', '<cmd>FzfLua files<cr>', desc = 'Find files' },
  { '<c-\\>', '<cmd>FzfLua resume<cr>', desc = 'Resume last command' },
  { '<leader>/', '<cmd>FzfLua live_grep_glob<cr>', desc = 'Live grep' },
  { '<leader>b/', '<cmd>FzfLua grep_curbuf<cr>', desc = 'Grep current buffer' },
  { '<leader>bb', '<cmd>FzfLua buffers<cr>', desc = 'Find buffers' },
  { '<leader>fc', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep current word' },
  { '<leader>fp', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
  { '<leader>fk', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document symbols' },
  {
    '<leader>fr',
    function()
      -- Read from ShaDa to include files that were already deleted from the buffer list.
      vim.cmd('rshada!')
      require('fzf-lua').oldfiles()
    end,
    desc = 'Recently opened files',
  },

  { '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>', desc = 'Document diagnostics' },
  { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
  { '<leader>wd', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', desc = 'Workspace diagnostics' },
  { '<leader>wk', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
}

M.whichkey = {
  ['f'] = { name = 'Find' },
  ['g'] = { name = 'Git' },
  -- ["/"] = { "<Cmd>Telescope live_grep<CR>", "which_key_ignore" },
}

return M
