return {
  {
    'rebelot/heirline.nvim',
    -- You can optionally lazy-load heirline on UiEnter
    -- to make sure all required plugins and colorschemes are loaded before setup
    event = 'UiEnter',
    dependencies = { 'Zeioth/heirline-components.nvim' },
    opts = function()
      local lib = require('heirline-components.all')
      return {
        statusline = { -- UI statusbar
          hl = { fg = 'fg', bg = 'bg' },
          lib.component.mode({ mode_text = {} }),
          lib.component.git_branch(),
          lib.component.file_info({ filename = { relative = true }, filetype = false, file_modified = {} }),
          lib.component.git_diff(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.fill(),
          lib.component.lsp(),
          -- lib.component.compiler_state(),
          -- lib.component.virtual_env(),
          lib.component.nav({ scrollbar = false }),
          -- lib.component.mode({ surround = { separator = 'right' } }),
        },
      }
    end,

    config = function(_, opts)
      local heirline = require('heirline')
      local heirline_components = require('heirline-components.all')

      -- Setup
      heirline_components.init.subscribe_to_events()
      heirline.load_colors(heirline_components.hl.get_colors())
      heirline.setup(opts)
    end,
  },
}
