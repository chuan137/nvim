local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Load your own plugins
  { import = 'plugins' },

  { -- Load lspone to setup lsp, cmp, formatting and etc
    'lspone',
    dev = true,
    import = 'lspone.plugins',
    init = function()
      vim.g.lspone_enable_conform = true
      vim.g.lspone_enable_copilot = true
    end,
    config = function()
      require('lspone.autocmds')
    end,
  },

  { -- Load LazyVim without importing the plugins.
    -- We will use the commands from the LazyVim package, but not keymaps.
    'LazyVim/LazyVim',
    version = false,
    opts = {
      defaults = {
        keymaps = false,
      },
      news = {
        lazyvim = false,
        neovim = false,
      },
      colorscheme = function()
        -- vim.cmd.colorscheme('base16-one-light')
        vim.cmd.colorscheme('base16-decaf')
        -- vim.cmd.colorscheme('base16-tomorrow-night-eighties')
      end,
    },
    config = function(_, opts)
      require('lazyvim').setup(opts)
    end,
  },
}, { -- Lazy options
  change_detection = { enabled = false },
  defaults = {
    lazy = false,
    version = '*', -- try installing the latest stable version for plugins that support semver
    -- version = false, -- always use the latest git commit
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        -- "netrwPlugin",
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
