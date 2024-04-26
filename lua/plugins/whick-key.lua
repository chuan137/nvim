return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require('which-key')
      local mappings = require('config.mappings')
      wk.setup(opts)
      wk.register(mappings.whichkey, { prefix = '<leader>' })
    end,
  },
}
