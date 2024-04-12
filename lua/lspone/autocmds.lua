local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- user event that loads after UIEnter + only if file buf is there
autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  group = augroup('lspone_file', { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_buf_get_option(args.buf, 'buftype')

    if not vim.g.ui_entered and args.event == 'UIEnter' then
      vim.g.ui_entered = true
    end

    if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "LspOneFile", modeline = false })
      vim.api.nvim_del_augroup_by_name('lspone_file')

      vim.schedule(function()
        vim.api.nvim_exec_autocmds('FileType', {})

        if vim.g.editorconfig then
          require('editorconfig').config(args.buf)
        end
      end, 0)
    end
  end,
})