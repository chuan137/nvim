return {
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      handlers = {
        gopls = function()
          require('lspconfig').gopls.setup({
            cmd = { 'gopls', 'serve' },
          })
        end,
      },
    },
  },
}
