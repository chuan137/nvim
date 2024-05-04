return {
  -- {
  --   'echasnovski/mini.nvim',
  --   event = 'VeryLazy',
  --   keys = {
  --     { '<leader>e', '<cmd>lua MiniFiles.open()<cr>', 'Open Mini Explorer' },
  --   },
  --   opts = {
  --     basics = {
  --       autocommands = {
  --         relnum_in_visual_mode = true,
  --       },
  --     },
  --     bracketed = {
  --       file = { suffix = '' },
  --     },
  --   },
  --   config = function(_, opts)
  --     require('mini.ai').setup(opts.ai or {})
  --     require('mini.basics').setup(opts.basics or {})
  --     require('mini.bracketed').setup(opts.bracketed or {})
  --     require('mini.comment').setup(opts.comment or {})
  --     require('mini.cursorword').setup(opts.cursorword or {})
  --     require('mini.files').setup(opts.files or {})
  --     require('mini.pairs').setup(opts.pairs or {})
  --     require('mini.surround').setup(opts.surround or {})
  --   end,
  -- },

  { 'echasnovski/mini.base16', lazy = false },

  {
    'echasnovski/mini.basics',
    lazy = false,
    opts = {
      autocommands = {
        relnum_in_visual_mode = true,
      },
    },
    config = function(_, opts)
      require('mini.basics').setup(opts)
    end,
  },

  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    config = function()
      require('mini.ai').setup()
    end,
  },

  {
    'echasnovski/mini.bracketed',
    event = 'VeryLazy',
    opts = { file = { suffix = '' } },
    config = function(_, opts)
      require('mini.bracketed').setup(opts)
    end,
  },

  {
    'echasnovski/mini.comment',
    event = 'VeryLazy',
    config = function()
      require('mini.comment').setup()
    end,
  },

  {
    'echasnovski/mini.cursorword',
    event = 'VeryLazy',
    config = function()
      require('mini.cursorword').setup()
    end,
  },

  {
    'echasnovski/mini.files',
    event = 'VeryLazy',
    keys = {
      -- { '<leader>e', '<cmd>lua MiniFiles.open()<cr>', 'Open Mini Explorer' },
      { '<leader>e', '<cmd>lua MiniFiles.open(vim.fn.expand("%:p"))<cr>', desc = 'Open Mini Explorer' },
    },
    config = function()
      require('mini.files').setup()
    end,
  },

  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    config = function()
      require('mini.pairs').setup()
    end,
  },

  {
    'echasnovski/mini.surround',
    event = 'VeryLazy',
    config = function()
      require('mini.surround').setup()
    end,
  },
}
