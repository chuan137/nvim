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
      vim.api.nvim_exec_autocmds('User', { pattern = 'LspOneFile', modeline = false })
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

autocmd('LspAttach', {
  group = augroup('lspone_attach', { clear = true }),
  callback = function(args)
    local function map(mode, key, cmd, desc)
      vim.keymap.set(mode, key, cmd, { buffer = args.buf, desc = desc })
    end
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover documentation')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', 'Go to definition')
    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Go to declaration')
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Go to implementation')
    map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Go to type definition')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', 'Go to reference')
    map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Show function signature')
    map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename symbol')
    map('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format file')
    map('x', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format selection')
    -- map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Execute code action')

    -- if vim.lsp.buf.range_code_action then
    --   map('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', 'Execute code action')
    -- else
    --   map('x', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Execute code action')
    -- end

    map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Show diagnostic')
    map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Previous diagnostic')
    map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next diagnostic')
  end,
})
