vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.lazy')
require('config.options')
require('config.autocmds')

-- load keymaps after plugins and commands
require('config.keymaps')

-- use base16 colorscheme after loading plugin mini-base16
-- vim.cmd.colorscheme('base16-decaf')
vim.cmd.colorscheme('base16-cupertino-light')
-- vim.cmd.colorscheme('base16-gruvbox-dark-medium')

local should_profile = os.getenv('NVIM_PROFILE')
if should_profile then
  require('profile').instrument_autocmds()
  if should_profile:lower():match('^start') then
    require('profile').start('*')
  else
    require('profile').instrument('*')
  end
end

local function toggle_profile()
  local prof = require('profile')
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = 'Save profile to:', completion = 'file', default = 'profile.json' }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format('Wrote %s', filename))
      end
    end)
  else
    prof.start('*')
  end
end

vim.keymap.set('', '<f8>', toggle_profile)

-- vim: ts=2 sts=2 sw=2 et
