local add = MiniDeps.add
local M = {}

M.opts = {
    workspaces = {
        {
            name = "sap",
            path = "~/Documents/vaults/sap",
        },
        {
            name = "personal",
            path = "~/Documents/vaults/personal",
        },
    },
    completion = {
        nvim_cmp = false,
        blink = true,
    },
    pickers = {
        name = "snacks.pick",
    },
}

M.setup = function()
    add({
        source = "obsidian-nvim/obsidian.nvim",
        checkout = "v3.11.0",
        monitor = "main",
        depends = {
            "nvim-lua/plenary.nvim",
        },
    })
    require("obsidian").setup(M.opts)
end

return M
