local keymaps = require('keymaps')

return {
  {
    'stevearc/oil.nvim',
    lazy = true,
    keys = keymaps.oil,
    opts = {
      default_file_explorer = false,
    }
  },
}
