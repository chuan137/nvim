local M = {}

---
--- Lsp Serveres
---
M.mason_opts = function()
  local lsp_zero = require('lsp-zero')
  local lspconfig = require('lspconfig')

  return {
    ensure_installed = {
      'gopls',
      'lua_ls',
      'pyright',
      'ruff_lsp',
    },

    handlers = {
      lsp_zero.default_setup,

      lua_ls = function()
        local lua_opts = lsp_zero.nvim_lua_ls()
        require('lspconfig').lua_ls.setup(lua_opts)
      end,

      pyright = function()
        -- Alternatively, we can use the lsp_zero.configure() api to store the
        -- server config, and reuse it later in project local setups.
        -- lsp_zero.configure('pyright', { ... })
        lspconfig.pyright.setup({
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
              -- autoImportCompletion = true,
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'basic',
                diagnosticSeverityOverrides = {
                  reportOptionalIterable = 'none',
                  reportOptionalSubscript = 'none',
                  reportOptionalMemberAccess = 'none',
                  -- reportUnusedVariable = "error",
                  -- reportUndefinedVariable = "none",
                },
              },
            },
          },
          handlers = {
            ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
              virtual_text = false,
              signs = true,
              underline = true,
              update_in_insert = true,
            }),
          },
        })
      end,

      ruff_lsp = function()
        lspconfig.ruff_lsp.setup({
          on_attach = function(client, bufnr)
            -- Use Pyright's hover provider
            client.server_capabilities.hoverProvider = false
          end,
          init_options = {
            settings = {
              lint = {
                enable = true,
                args = { '--extend-ignore', 'F841' },
              },
            },
          },
        })
      end,
    },
  }
end

---
--- Autocompletion config
---
M.cmp_opts = function()
  local lsp_zero = require('lsp-zero')

  local cmp = require('cmp')
  local cmp_action = lsp_zero.cmp_action()
  local cmp_format = lsp_zero.cmp_format()
  local has_luasnip, luasnip = pcall(require, 'luasnip')
  local has_copilot, copilot_suggestion = pcall(require, 'copilot.suggestion')

  local cmp_select_opts = { behavior = cmp.SelectBehavior.Replace }

  -- cmp.setup {
  return {
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    formatting = cmp_format,
    mapping = cmp.mapping.preset.insert({
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({ select = true }),

      -- Dimiss copilot suggestion or cmp menu
      ['<C-e>'] = cmp.mapping(function(fallback)
        if has_copilot and copilot_suggestion.is_visible() then
          copilot_suggestion.dismiss()
        elseif not cmp.abort() then
          fallback()
        end
      end, { 'i', 's' }),

      -- Ctrl+Space to trigger completion menu
      ['<C-Space>'] = cmp.mapping.complete(),

      -- scroll up and down the documentation window
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),

      -- Navigate between snippet placeholder
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),

      -- Super tab integrated with copilot, cmp and luasnip
      ['<Tab>'] = cmp.mapping(function(fallback)
        local col = vim.fn.col('.') - 1

        if has_copilot and copilot_suggestion.is_visible() then
          copilot_suggestion.accept()
        elseif cmp.visible() then
          cmp.select_next_item(cmp_select_opts)
        elseif has_luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(cmp_select_opts),
    }),
    -- sources = cmp.config.sources {
    -- { name = 'nvim_lsp' },
    --   -- { name = 'luasnip' },
    --   -- { name = 'buffer' },
    -- },
  }
end

M.copilot_opts = {
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
}

return M
