local add = MiniDeps.add
local M = {}

M.setup = function()
    add({ source = "folke/which-key.nvim" })
    local wk = require("which-key")
    wk.setup({
        preset = "helix",
        -- win = { col = -1, row = 0 }
    })
end

return M
