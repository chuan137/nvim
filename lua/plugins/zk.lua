return function()
    MiniDeps.add({ source = "zk-org/zk-nvim" })

    require("zk").setup({
        picker = "snacks_picker",

        lsp = {
            config = {
                name = "zk",
                cmd = { "zk", "lsp" },
                filetypes = { "markdown" },
            },

            auto_attach = {
                enabled = true,
            },
        },
    })
end
