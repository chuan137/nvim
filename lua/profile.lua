local should_profile = os.getenv('NVIM_PROFILE')
local has_profile, prof = pcall(require, 'profile')

if should_profile and has_profile then
  prof.instrument_autocmds()
  if should_profile:lower():match('^start') then
    prof.start('*')
  else
    prof.instrument('*')
  end
end

local function toggle_profile()
  if not has_profile then
    vim.notify('Profile not available')
    return
  end
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
