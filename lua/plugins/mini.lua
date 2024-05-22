return {
  {
    'echasnovski/mini.base16',
    lazy = false,
  },

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
    'echasnovski/mini.align',
    event = 'VeryLazy',
    config = function()
      require('mini.align').setup()
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
    'echasnovski/mini.diff',
    event = 'VeryLazy',
    -- enabled = false,
    config = function()
      require('mini.diff').setup()
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
      require('mini.files').setup({
        mappings = {
          go_in_plus = '<cr>',
        },
      })
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
