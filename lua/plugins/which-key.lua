return function()
    MiniDeps.add({ source = "folke/which-key.nvim" })
    local wk = require("which-key")
    wk.setup({
        preset = "helix",
        -- win = { col = -1, row = 0 }
    })
    wk.add({
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>u", group = "Toggle" },
        { "<leader>p", hidden = true },
        { "<leader>P", hidden = true },
        { "<leader>y", hidden = true },
        { "<leader>Y", hidden = true },
        { "<leader>w", hidden = true },
        { "<leader>/", icon = "" },
        { "<leader>?", icon = "" },
        { "<leader><cr>", icon = MiniIcons.get('os', 'macos') },
    })
end
