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
        mode = '',
        desc = 'Conform: Format buffer',
      },
    },
    init = function()
      --   vim.api.nvim_create_user_command('FormatWithConform',
      --     function ()
      -- require('conform').format({ async = true, lsp_fallback = true })
      --     end, { nargs = 0 })

      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      -- vim.o.formatexpr = "v:lua.require'conform'.formatexpr({timeout_ms=1000})"
      -- vim.o.formatexpr = 'FormatWithConform'
    end,
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        -- use ruff_lsp for python formatting
        -- python = { 'isort', 'ruff_format' },
        python = { { 'yapf', 'ruff_format' } },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' } },
      },
      log_level = vim.log.levels.DEBUG,
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      --  with opts = {} to trigger the default config, otherwise mason's bin is not added to the path
      { 'williamboman/mason.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
      'folke/neodev.nvim',
    },
    event = 'User LspOneFile',
    config = function()
      local lspconfig = require('lspconfig')
      local on_attach = lspone_config.on_attach
      local capabilities = lspone_config.capabilities
      local handlers = lspone_config.lsphandler_diagno_no_virtual_text

      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('neodev').setup({})
      lspconfig.lua_ls.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
      lspconfig.pyright.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
      -- lspconfig.basedpyright.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
      -- lspconfig.ruff.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
      lspone_config.ruff_lsp.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
      lspconfig.gopls.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    cmd = 'CmpStatus',
    dependencies = {
      'onsails/lspkind-nvim',
      'L3MON4D3/LuaSnip',
    },
    event = 'InsertEnter',
    opts = lspone_config.cmp_opts,
    config = function(_, opts)
      -- local lsp_zero = require('lsp-zero')
      -- lsp_zero.extend_cmp()
      require('cmp').setup(opts)
    end,
  },

  {
    'github/copilot.vim',
    enabled = true,
    event = 'User LspOneFile',
    config = function()
      vim.keymap.set('i', '<C-H>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_no_tab_map = true
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      -- add copilot symbol to lualine
      { 'AndreM222/copilot-lualine', enabled = has_lualine },
    },
    -- enabled = vim.g.lspone_enable_copilot,
    enabled = false,
    event = 'User LspOneFile',
    opts = lspone_config.copilot_opts,
    config = function(_, opts)
      require('copilot').setup(opts)
    end,
  },
}
