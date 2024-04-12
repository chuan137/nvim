return {

  {
    'nvim-treesitter/nvim-treesitter',
    -- enabled = false,
    event = 'User LspOneFile',
    dependencies = {
      'windwp/nvim-ts-autotag',
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'go', 'lua', 'markdown', 'python', 'vim', 'vimdoc' },
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
          scope_incremental = '<C-s>',
          node_decremental = '<M-space>',
        },
      },
      matchup = {
        enable = true,
        enable_quotes = true,
        -- disable = function(_, bufnr) return utils.is_big_file(bufnr) end,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      require('ts_context_commentstring').setup({ enable = true, enable_autocmd = false }) -- Enable commentstring
      vim.g.skip_ts_context_commentstring_module = true -- Increase performance
    end,
  },
}
