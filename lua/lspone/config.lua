local M = {}

---
--- Lsp Serveres
---
function M.mason_opts()
  local lspconfig = require('lspconfig')

  local function on_attach(client, bufnr)
    local function map(mode, key, cmd, desc)
      vim.keymap.set(mode, key, cmd, { noremap = true, silent = true, buffer = bufnr, desc = 'Lsp: ' .. desc })
    end

    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover documentation')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', 'Go to definition')
    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Go to declaration')
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Go to implementation')
    map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Go to type definition')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', 'Go to reference')
    map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Show function signature')
    map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Show diagnostic')
    map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Previous diagnostic')
    map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next diagnostic')
    map('i', '<C-l>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Show function signature')

    map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename symbol')
    -- map('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format file')
    -- map('x', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format selection')
    map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Execute code action')

    if vim.lsp.buf.range_code_action then
      map('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', 'Execute code action')
    else
      map('x', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Execute code action')
    end

    -- speed up lsp start up
    -- https://www.reddit.com/r/neovim/comments/1cjn94h/comment/l2iffsd/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    client.server_capabilities.semanticTokensProvider = nil
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities()

  return {
    ensure_installed = {
      'gopls',
      'lua_ls',
      'pyright',
      'ruff_lsp',
    },

    handlers = {
      function(server_name)
        if server_name == 'ruff' then
          return
        end
        lspconfig[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
      end,

      lua_ls = function()
        -- local lua_opts = lsp_zero.nvim_lua_ls()
        require('neodev').setup({})
        lspconfig.lua_ls.setup({ on_attach = on_attach, capabilities = capabilities })
      end,

      ['pyright'] = function()
        -- Alternatively, we can use the lsp_zero.configure() api to store the
        -- server config, and reuse it later in project local setups.
        -- lsp_zero.configure('pyright', { ... })
        lspconfig.pyright.setup({
          on_attach = on_attach,
          capabilities = capabilities,
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
                  reportUndefinedVariable = 'none',
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
            on_attach(client, bufnr)
          end,
          capabilities = capabilities,
          init_options = {
            settings = {
              lint = {
                enable = true,
                args = { '--extend-ignore', 'F841' },
                -- args = { '--extend-ignore', 'F821' },
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
function M.cmp_opts()
  local lsp_zero = require('lsp-zero')

  local cmp = require('cmp')
  local cmp_action = lsp_zero.cmp_action()
  local cmp_format = lsp_zero.cmp_format({})
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
