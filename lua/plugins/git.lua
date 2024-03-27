return {

  -- fugitive and rhubarb
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    dependencies = { 'tpope/vim-rhubarb' },
    init = function()
      vim.g.github_enterprise_urls = { 'https://github.wdf.sap.corp' }
    end,
  },

  {
    'TimUntersberger/neogit',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    opts = {},
  },
}
