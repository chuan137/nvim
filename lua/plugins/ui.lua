return {
  {
    'rebelot/heirline.nvim',
    -- You can optionally lazy-load heirline on UiEnter
    -- to make sure all required plugins and colorschemes are loaded before setup
    event = 'UiEnter',
    dependencies = {
      { 'zeioth/heirline-components.nvim' },
    },
    opts = function()
      local lib = require('heirline-components.all')
      return {
        tabline = { -- UI upper bar
          lib.component.tabline_conditional_padding(),
          lib.component.tabline_buffers(),
          lib.component.fill({ hl = { bg = 'tabline_bg' } }),
          lib.component.tabline_tabpages(),
        },
        statuscolumn = { -- UI left column
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          lib.component.foldcolumn(),
          lib.component.numbercolumn(),
          lib.component.signcolumn(),
        } or nil,
        statusline = { -- UI statusbar
          hl = { fg = 'fg', bg = 'bg' },
          lib.component.mode(),
          lib.component.file_info({ filename = { modify = ':p:.' }, filetype = false, file_modified = {} }),
          lib.component.git_branch(),
          lib.component.git_diff(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.fill(),
          lib.component.lsp(),
          lib.component.compiler_state(),
          lib.component.virtual_env(),
          lib.component.nav({ percentage = { padding = { right = 1 } }, scrollbar = false }),
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
