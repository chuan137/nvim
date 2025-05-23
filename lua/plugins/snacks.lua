return function()
    MiniDeps.add({ source = "folke/snacks.nvim" })
    require("snacks").setup({
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        -- notifier = { enabled = true },
        -- bigfile = { enabled = true },
        -- dashboard = { enabled = true },
        -- explorer = { enabled = true },
        -- scroll = { enabled = true },
    })
    require("config.pickers")
end
