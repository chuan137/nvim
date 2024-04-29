return {
  -- { 'folke/tokyonight.nvim' },

  {
    'sainnhe/gruvbox-material',
    init = function()
      -- vim.opt.background = 'dark'
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_background = 'medium' -- 'hard' | 'medium' | 'soft'
      vim.g.gruvbox_material_foreground = 'material' -- 'material' | 'mix' | 'original'
      vim.g.gruvbox_material_ui_contrast = 'high' -- 'low' | 'high'
      vim.g.gruvbox_material_diagnostic_line_highlight = 0 -- 0 | 1
    end,
  },
}
