return {

  {
    'ibhagwan/fzf-lua',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
    cmd = 'FzfLua',
    keys = require('keymaps').fzflua,
    opts = function()
      local actions = require('fzf-lua.actions')

      return {
        winopts = {
          height = 0.37,
          width = 1,
          row = 1,
          col = 0,
          border = 'none',
          preview = {
            scrollbar = false,
            layout = 'flex',
            vertical = 'up:45%',
            border = 'noborder',
            hidden = 'hidden',
          },
        },
        -- Make stuff better combine with the editor.
        fzf_colors = {
          gutter = { 'bg', 'NormalFloat' },
          info = { 'fg', 'Conditional' },
          scrollbar = { 'bg', 'NormalFloat' },
          separator = { 'fg', 'Comment' },
          ['bg+'] = { 'bg', 'NormalFloat' },
          ['fg+'] = { 'fg', 'NormalFloat', "bold", "underline" },
        },
        fzf_opts = {
          ['--info'] = 'default',
        },
        keymap = {
          builtin = {
            ['?'] = 'toggle-help',
            ['<C-a>'] = 'toggle-fullscreen',
            ['<C-i>'] = 'toggle-preview',
            ['<C-f>'] = 'preview-page-down',
            ['<C-b>'] = 'preview-page-up',
          },
          fzf = {
            ['alt-s'] = 'toggle',
            ['alt-a'] = 'toggle-all',
          },
        },
        -- global_git_icons = false,
        -- Configuration for specific commands.
        files = {
          winopts = {
            preview = { hidden = 'hidden' },
          },
        },
        -- grep = {
        --   header_prefix = icons.misc.search .. " ",
        -- },
        helptags = {
          actions = {
            -- Open help pages in a vertical split.
            ['default'] = actions.help_vert,
          },
        },
        -- lsp = {
        --   symbols = {
        --     symbol_icons = icons.symbol_kinds,
        --   },
        -- },
        oldfiles = {
          include_current_session = true,
        },
      }
    end,
    config = function(_, opts)
      vim.cmd [[
        hi link FzfLuaHeaderBind FzfLuaHeader
      ]]
      require('fzf-lua').setup(opts)
    end,
  },
}
