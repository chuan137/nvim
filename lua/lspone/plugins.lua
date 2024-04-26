local lspone_config = require('lspone.config')
local has_lualine, _ = pcall(require, 'lualine')

return {
  {
    'stevearc/conform.nvim',
    cmd = 'ConformInfo',
    keys = {
      {
        '<F3>',
        function()
          require('conform').format({ async = true, lsp_fallback = true })
        end,
        desc = 'Conform Format buffer',
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
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      lsp_zero.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»',
      })
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    event = 'User LspOneFile',
    opts = lspone_config.mason_opts,
    config = function(_, opts)
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()
      require('mason').setup({})
      require('mason-lspconfig').setup(opts)
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    cmd = 'CmpStatus',
    dependencies = {
      'L3MON4D3/LuaSnip',
    },
    event = 'InsertEnter',
    opts = lspone_config.cmp_opts,
    config = function(_, opts)
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()
      require('cmp').setup(opts)
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      -- add copilot symbol to lualine
      { 'AndreM222/copilot-lualine', enabled = has_lualine },
    },
    enabled = vim.g.lspone_enable_copilot,
    event = 'User LspOneFile',
    opts = lspone_config.copilot_opts,
    config = function(_, opts)
      require('copilot').setup(opts)
    end,
  },

}
