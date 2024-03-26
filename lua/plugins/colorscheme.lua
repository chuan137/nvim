return {
  {
    'folke/tokyonight.nvim',
    init = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme('tokyonight')
    end,
  },
}
