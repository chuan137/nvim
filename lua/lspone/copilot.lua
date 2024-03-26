local has_lualine, _ = pcall(require, 'lualine')

return {

  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = false,
          auto_refresh = true,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom', -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            dismiss = false, -- use <c-e> to dismiss completion, integrated into nvim-cmp mapping
            accept = false, -- use <tab> to accept completion, integrated into nvim-cmp mapping
            accept_word = false,
            accept_line = '<C-l>',
            next = '<M-]>',
            prev = false,
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = true,
          gitcommit = true,
          gitrebase = true,
          hgcommit = true,
          svn = true,
          cvs = true,
          ['.'] = true,
        },
        server_opts_overrides = {},
      }
    end,
  },

  -- add copilot symbol to lualine
  {
    'AndreM222/copilot-lualine',
    enabled = has_lualine,
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   opts = function(_, opts)
  --     table.insert(opts.sections.lualine_x, 2, "copilot")
  --   end,
  -- },
}
