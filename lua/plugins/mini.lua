return {
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    keys = {
      {'<leader>e', '<cmd>lua MiniFiles.open()<cr>', 'Open Mini Explorer'},
    },
    opts = {
      basics = {
        autocommands = {
          relnum_in_visual_mode = true,
        },
      },
      bracketed = {
        file = { suffix = '' },
      },
    },
    config = function(_, opts)
      require('mini.ai').setup(opts.ai or {})
      require('mini.basics').setup(opts.basics or {})
      require('mini.bracketed').setup(opts.bracketed or {})
      require('mini.comment').setup(opts.comment or {})
      require('mini.cursorword').setup(opts.cursorword or {})
      require('mini.files').setup(opts.files or {})
      require('mini.pairs').setup(opts.pairs or {})
      require('mini.surround').setup(opts.surround or {})
    end,
  },
}
