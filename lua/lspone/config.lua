local M = {}

---
--- Lsp Serveres
---
function M.on_attach(client, bufnr)
  -- speed up lsp start up
  -- https://www.reddit.com/r/neovim/comments/1cjn94h/comment/l2iffsd/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  client.server_capabilities.semanticTokensProvider = nil

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
  map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Execute code action')
  if vim.lsp.buf.range_code_action then
    map('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', 'Execute code action')
  else
    map('x', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Execute code action')
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.lsphandler_diagno_no_virtual_text = {
  ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = true,
  }),
}

M.pyright = {
  setup = function(opts)
    local lspconfig = require('lspconfig')
    local on_attach = opts.on_attach or M.on_attach
    local capabilities = opts.capabilities or M.capabilities
    local handlers = opts.handlers or {}

    local settings = vim.tbl_extend('force', {
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
    }, opts.settings or {})

    lspconfig.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = settings,
      handlers = handlers,
    })
  end,
}

M.ruff_lsp = {
  setup = function(opts)
    local lspconfig = require('lspconfig')
    local on_attach = opts.on_attach or M.on_attach
    local capabilities = opts.capabilities or M.capabilities
    local handlers = opts.handlers or {}

    local init_options = vim.tbl_extend('force', {
      settings = {
        lint = {
          enable = true,
          args = { '--extend-ignore', 'F841' },
        },
      },
    }, opts.init_options or {})

    lspconfig.ruff_lsp.setup({
      on_attach = M.on_attach,
      capabilities = M.capabilities,
      init_options = init_options,
      handlers = handlers,
    })
  end,
}

---
--- Autocompletion config
---
function M.cmp_opts()
  local cmp = require('cmp')
  local lspkind = require('lspkind')
  local has_luasnip, luasnip = pcall(require, 'luasnip')
  local has_copilot, copilot_suggestion = pcall(require, 'copilot.suggestion')

  local cmp_select_opts = { behavior = cmp.SelectBehavior.Replace }

  local function luasnip_jump_forward()
    return cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' })
  end

  local function luasnip_jump_backward()
    return cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  end

  local function cmp_copilot_luasnip_supertab()
    return cmp.mapping(function(fallback)
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
    end, { 'i', 's' })
  end
  local function cmp_luasnip_shift_supertab()
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  end

  -- cmp.setup {
  return {
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    snippet = { -- configure how nvim-cmp interacts with snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
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
      ['<C-Space>'] = cmp.mapping.complete({}),

      -- scroll up and down the documentation window
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),

      -- Navigate between snippet placeholder
      -- ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      -- ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      ['<C-j>'] = luasnip_jump_forward(),
      ['<C-k>'] = luasnip_jump_backward(),

      -- Super tab integrated with copilot, cmp and luasnip
      -- ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(cmp_select_opts),
      ['<Tab>'] = cmp_copilot_luasnip_supertab(),
      ['<S-Tab>'] = cmp_luasnip_shift_supertab(),
    }),
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text',
        menu = {
          nvim_lsp = '[LSP]',
          luasnip = '[US]',
          nvim_lua = '[Lua]',
          path = '[Path]',
          buffer = '[Buffer]',
          emoji = '[Emoji]',
          omni = '[Omni]',
        },
      }),
    },
    sources = {
      { name = 'nvim_lsp' }, -- For nvim-lsp
      { name = 'luasnip' }, -- For luasnip user.
      { name = 'path' }, -- for path completion
      { name = 'buffer', keyword_length = 2 }, -- for buffer word completion
      -- { name = "ultisnips" }, -- For ultisnips user.
      -- { name = "emoji", insert = true }, -- emoji completion
    },
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
