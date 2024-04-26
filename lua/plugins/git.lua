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
    lazy = true,
    keys = require('config.mappings').neogit,
    cmd = 'Neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    opts = {},
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'User LspOneFile',
    config = function(_, opts)
      require('gitsigns').setup(opts)
    end,
    opts = {
      on_attach = function(buffer)
        local wk = require('which-key')

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          wk.register({ [l] = { name = desc } })
        end

        local mappings = require('config.mappings').gitsigns
        for _, m in ipairs(mappings) do
          map(m.mode or 'n', m[1], m[2], m.desc)
        end
      end,
    },
  },
}
