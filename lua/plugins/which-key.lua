return function()
    MiniDeps.add({ source = "folke/which-key.nvim" })
    local wk = require("which-key")
    wk.setup({
        preset = "helix",
        -- win = { col = -1, row = 0 }
    })

    local icon_file = MiniIcons.get("lsp", "file")
    local icon_key = MiniIcons.get("lsp", "key")
    local icon_search = ""

    wk.add({
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "Toggle" },
        { "<leader>p", hidden = true },
        { "<leader>P", hidden = true },
        { "<leader>y", hidden = true },
        { "<leader>Y", hidden = true },
        { "<leader>w", hidden = true },

        { "g/", icon = icon_search },
        { "g^", icon = icon_search },
        { "<leader>,", icon = icon_key },
        { "<leader>/", icon = icon_search },
        { "<leader>^", icon = icon_search },
        { "<leader>?", icon = icon_search },
        { "<leader>b", icon = icon_file },
        { "<leader><space>", icon = icon_file },
        { "<leader><backspace>", icon = icon_file },
        { "<leader><cr>", icon = icon_file },
        { "<leader>@", icon = icon_file },
    })
end
