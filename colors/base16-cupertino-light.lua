require('mini.base16').setup({
  palette = {
    base00 = "#f0f0f0",  -- white
    base01 = "#d0dfd5",
    base02 = "#ddd9cf",
    base03 = "#70809f",
    base04 = "#808080",
    base05 = "#404040",
    base06 = "#404040",
    base07 = "#5e5e5e", -- black
    base08 = "#c41a15", -- red
    base09 = "#eb8500", -- orange
    base0A = "#5d5286", -- yellow
    base0B = "#007400", -- green
    base0C = "#318495", -- cyan
    base0D = "#1d3276", -- blue
    base0E = "#792691", -- purple
    base0F = "#826b28", -- brown
  },
})

vim.g.colors_name = "base16-cupertino-light"
vim.cmd[[
  hi CursorLineNr guifg=#f0f0f0 guibg=#70809f
  set cursorlineopt=number
  " hi diffAdded guibg=#c0c9c0
  " hi diffRemoved guibg=#c0c9c0
  " hi diffChanged guibg=#c0c9c0
  " hi LineNr guibg=none
  " hi SignColumn guibg=none
  " hi GitSignsAdd guibg=none
  " hi GitSignsChange guibg=none
  " hi GitSignsDelete guibg=none
]]

-- base02 = "#afc0d0",
-- base00: "ffffff" # White
-- base01: "c0c0c0"
-- base02: "c0c0c0"
-- base03: "808080"
-- base04: "808080"
-- base05: "404040"
-- base06: "404040"
-- base07: "5e5e5e" # Black
-- base08: "c41a15" # Red
-- base09: "eb8500" # Orange
-- base0A: "826b28" # Yellow
-- base0B: "007400" # Green
-- base0C: "318495" # Cyan
-- base0D: "0000ff" # Blue
-- base0E: "a90d91" # Purple
-- base0F: "826b28" # Brown
