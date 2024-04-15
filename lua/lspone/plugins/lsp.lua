local lspone_config = require('lspone.config')
local has_lualine, _ = pcall(require, 'lualine')

return {
  { 'neovim/nvim-lspconfig', event = 'VeryLazy' },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = lspone_config.setup,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    event = 'User LspOneFile',
    opts = lspone_config.mason_opts,
    config = function(_, opts)
      require('mason').setup({})
      require('mason-lspconfig').setup(opts)
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
    },
    cmd = 'CmpStatus',
    event = 'InsertEnter',
    opts = lspone_config.cmp_opts,
  },

  {
    'stevearc/conform.nvim',
    enabled = vim.g.lspone_enable_conform,
    cmd = 'ConformInfo',
    keys = {
      {
	      -- stylua: ignore start
        '<F3>',
        function() require('conform').format({ async = true, lsp_fallback = true }) end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'isort', 'black' },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' } },
      },
    },
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'VeryLazy',
    enabled = vim.g.lspone_enable_copilot,
    config = function()
      require('copilot').setup({
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
            next = '<M-Space>',
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
      })
    end,
  },

  -- add copilot symbol to lualine
  {
    'AndreM222/copilot-lualine',
    enabled = has_lualine,
  },
}
