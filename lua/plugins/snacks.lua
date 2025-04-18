return {
    "snacks.nvim",
    before = function()
        MiniDeps.add({ source = "folke/snacks.nvim" })
    end,
    -- cmd = {
    --     "Snacks",
    -- },
    after = function()
        require("snacks").setup({
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            statuscolumn = { enabled = true },
        })
        require("config.pickers")
    end,
}
