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
  change_detection = { enabled = false },
  defaults = {
    version = '*', -- try installing the latest stable version for plugins that support semver
    -- version = false, -- always use the latest git commit
  },
  spec = {
    -- Load plugins from lspone
    {
      import = 'lspone.lspone',
      init = function()
        vim.g.lspone_enable_conform = true
        vim.g.lspone_enable_copilot = true
      end,
    },

    -- Load the LazyVim configuration without importing its plugins.
    -- We can reuse the autocmds defined provided by LazyVim
    {
      'LazyVim/LazyVim',
      version = false,
      config = function()
        require('lazyvim.config.autocmds')
      end,
    },

    { import = 'plugins' },
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

-- vim: ts=2 sts=2 sw=2 et
