return {
  { -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },

  {
    'stevearc/profile.nvim',
    enabled = false,
  },

  {
    'norcalli/nvim-colorizer.lua',
    lazy = false,
    init = function()
      vim.opt.termguicolors = true
    end,
    config = function()
      require('colorizer').setup()
    end,
  },
}
