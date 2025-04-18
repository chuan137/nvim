return {
    "nvim-treesitter",
    event = "DeferredUIEnter",
    before = function()
    end,
    after = function()
        MiniDeps.add({
            source = "nvim-treesitter/nvim-treesitter",
            checkout = "master",
            monitor = "main",
            hooks = {
                post_checkout = function()
                    vim.cmd("TSUpdate")
                end,
            },
        })
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vimdoc", "go", "python" },
            highlight = { enable = true },
        })
    end,
}
