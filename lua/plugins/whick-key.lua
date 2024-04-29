return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require('which-key')
      local keymaps = require('config.keymaps')
      wk.setup(opts)
      wk.register(keymaps.whichkey, { prefix = '<leader>' })
    end,
  },
}
