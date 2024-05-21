local keymaps = require('config.keymaps')

return {

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
    keys = keymaps.neogit,
    cmd = 'Neogit',
    tag = 'v0.0.1',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {},
  },

  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    opts = {
      default_args = {
        DiffviewOpen = { '--imply-local' },
      },
    },
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

        local mappings = keymaps.gitsigns
        for _, m in ipairs(mappings) do
          map(m.mode or 'n', m[1], m[2], m.desc)
        end
      end,
    },
  },
}
