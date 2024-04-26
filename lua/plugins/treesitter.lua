return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  event = 'VeryLazy',
  cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
  keys = {
    { '<c-space>', desc = 'Increment Selection' },
    { '<bs>', desc = 'Decrement Selection', mode = 'x' },
  },
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'html',
      'go',
      'lua',
      'markdown',
      'python',
      'vim',
      'vimdoc',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    autotag = { enable = true },
    highlight = {
      enable = true,
      -- disable = function(_, bufnr) return utils.is_big_file(bufnr) end,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
    matchup = {
      enable = true,
      enable_quotes = true,
      -- disable = function(_, bufnr) return utils.is_big_file(bufnr) end,
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
        goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
        goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
        goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
      },
      -- select = {
      --   enable = true,
      --
      --   -- Automatically jump forward to textobj, similar to targets.vim
      --   lookahead = true,
      --
      --   keymaps = {
      --     -- You can use the capture groups defined in textobjects.scm
      --     ['af'] = '@function.outer',
      --     ['if'] = '@function.inner',
      --     ['ac'] = '@class.outer',
      --     -- You can optionally set descriptions to the mappings (used in the desc parameter of
      --     -- nvim_buf_set_keymap) which plugins like which-key display
      --     ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
      --     -- You can also use captures from other query groups like `locals.scm`
      --     ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
      --   },
      --   -- You can choose the select mode (default is charwise 'v')
      --   --
      --   -- Can also be a function which gets passed a table with the keys
      --   -- * query_string: eg '@function.inner'
      --   -- * method: eg 'v' or 'o'
      --   -- and should return the mode ('v', 'V', or '<c-v>') or a table
      --   -- mapping query_strings to modes.
      --   selection_modes = {
      --     ['@parameter.outer'] = 'v', -- charwise
      --     ['@function.outer'] = 'V', -- linewise
      --     ['@class.outer'] = '<c-v>', -- blockwise
      --   },
      --   -- If you set this to `true` (default is `false`) then any textobject is
      --   -- extended to include preceding or succeeding whitespace. Succeeding
      --   -- whitespace has priority in order to act similarly to eg the built-in
      --   -- `ap`.
      --   --
      --   -- Can also be a function which gets passed a table with the keys
      --   -- * query_string: eg '@function.inner'
      --   -- * selection_mode: eg 'v'
      --   -- and should return true or false
      --   include_surrounding_whitespace = true,
      -- },
    },
  },
  init = function()
    vim.g.skip_ts_context_commentstring_module = true -- Increase performance
  end,
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
    require('treesitter-context').setup({ enable = true, max_lines = 5 }) -- Enable context
    require('ts_context_commentstring').setup({ enable = true, enable_autocmd = false }) -- Enable commentstring
  end,
}
