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
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "Toggle" },
        { "<leader>p", hidden = true },
        { "<leader>P", hidden = true },
        { "<leader>y", hidden = true },
        { "<leader>Y", hidden = true },
        { "<leader>w", hidden = true },
        { "<leader>/", icon = "" },
        { "<leader>@", icon = "" },
        { "<leader>g/", icon = "" },
        { "<leader>g@", icon = "" },
        { "<leader>b", icon = MiniIcons.get("default", "file")},  -- buffer
        { "<leader>]", icon = MiniIcons.get("default", "file")},  -- buffer
        { "<leader>,", icon = MiniIcons.get("lsp", "keyword")},  -- symbols
        { "<leader>[,", icon = MiniIcons.get("lsp", "keyword")},  -- symbols
        { "<leader>],", icon = MiniIcons.get("lsp", "keyword")},  -- symbols
        { "<leader><cr>", icon = MiniIcons.get("os", "computer") },
    })
end
