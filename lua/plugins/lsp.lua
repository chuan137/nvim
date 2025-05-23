return function()
    MiniDeps.add({
        source = "williamboman/mason-lspconfig.nvim",
        depends = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    })
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("config.lspconfig").setup()
end
