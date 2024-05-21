local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- always open quickfix window automatically.
-- this uses cwindows which will open it only if there are entries.
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = augroup('AutoOpenQuickfix'),
  pattern = { '[^l]*' },
  command = 'cwindow',
})

-- Search python function definition
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('PyFuncDefinition'),
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
vim.api.nvim_create_autocmd('CmdlineLeave', {
  desc = 'clear cmdline after 3 seconds',
  group = augroup('ClearCmdlineOnLeave'),
  callback = function()
    vim.fn.timer_start(3000, function()
      vim.cmd('echon ""')
    end)
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('SearchDefsRefs'),
  --   pattern = '*',
  callback = function()
    -- search <cword> using grep
    local function search_def()

    end
    vim.keymap.set('n', 'gk', search_def, { buffer = 0 })
  end,
})

-- load file into buffer
--local bufnr = vim.api.nvim_create_buf(true, false)
-- vim.api.nvim_buf_set_name(bufnr, './file')
-- vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
vim.api.nvim_create_user_command('LoadFile',
  function(opts)
    local file = opts.args
    local bufnr = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(bufnr, file)
    vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
  end, { nargs = 1, complete = 'file'})
