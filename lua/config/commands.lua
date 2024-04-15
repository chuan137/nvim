-- always open quickfix window automatically.
-- this uses cwindows which will open it only if there are entries.
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('AutoOpenQuickfix', { clear = true }),
  pattern = { '[^l]*' },
  command = 'cwindow',
})

-- Search python function definition
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('PyFuncDefinition', { clear = true }),
  pattern = 'python',
  callback = function()
    local search_func_def = function()
      local has_fzf, fzf = pcall(require, 'fzf-lua')
      if has_fzf then
        fzf.grep({
          prompt = 'Search for function definition: ',
          search = 'def ' .. vim.fn.expand('<cword>') .. '(',
        })
      else
        vim.cmd('silent! grep! def\\ <cword>(')
        vim.cmd('echon " "')
      end
    end

    vim.keymap.set('n', '<C-]>', search_func_def, { buffer = 0 })

    -- vim.keymap.set('n', '<C-]>', function()
    --   local lsp_found_def = false
    --   vim.lsp.buf.definition({ on_list = function(options)
    --     print('definition found')
    --     lsp_found_def = true
    --   end})
    --   if lsp_found_def == false then
    --     print('No definition found, search with grep')
    --     search_def_py()
    --   end
    -- end, { buffer = 0 })
  end,
})

-- clear cmdline after 3 seconds
-- vim.api.nvim_create_autocmd('CmdlineLeave', {
--   desc = 'clear cmdline after 3 seconds',
--   group = vim.api.nvim_create_augroup('ClearCmdlineOnLeave', { clear = true }),
--   callback = function()
--     vim.fn.timer_start(3000, function()
--       vim.cmd('echon ""')
--     end)
--   end,
-- })
