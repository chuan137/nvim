local M = {}

M.setup = function()
  local lsp_zero = require('lsp-zero')

  lsp_zero.extend_lspconfig()

  lsp_zero.on_attach(function(_, bufnr)
    local exclude_keymaps = {}
    if vim.g.lspone_enable_conform then
      exclude_keymaps = { '<F3>' }
    end
    lsp_zero.default_keymaps({ buffer = bufnr, exclude = exclude_keymaps })
  end)

  lsp_zero.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»',
  })
end

---
--- Lsp Serveres
---
M.mason_opts = function()
  local lsp_zero = require('lsp-zero')

  return {
    ensure_installed = {
      'gopls',
      'lua_ls',
      'pyright',
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
        require('lspconfig').pyright.setup({
          settings = {
            -- pyright = {
            --   disableOrganizeImports = true,
            -- },
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = 'workspace', -- openFilesOnly, workspace
                typeCheckingMode = 'basic', -- off, basic, strict
                diagnosticSeverityOverrides = {
                  reportUndefinedVariable = false,
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
    },
  }
end

---
--- Autocompletion config
---
M.cmp_opts = function()
  local cmp = require('cmp')
  local cmp_action = require('lsp-zero').cmp_action()
  local cmp_format = require('lsp-zero').cmp_format()
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

return M

-- vim: ts=2 sts=2 sw=2 et
