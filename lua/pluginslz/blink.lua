local lz = require("lz.n")
local add = MiniDeps.add

return({
    "blink.cmp",
    before = function()
        add({ source = "saghen/blink.cmp", checkout = "v1.*" })
        add({ source = "rafamadriz/friendly-snippets" })
        lz.trigger_load("friendly-snippets")
    end,
    event = "InsertEnter",
    after = function()
        require("blink.cmp").setup({
            enabled = function()
                return not vim.tbl_contains({ "minifiles" }, vim.bo.filetype)
            end,
            keymap = {
                preset = "enter",
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = { documentation = { auto_show = false } },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = {
                enabled = true,
            },
        })
        vim.lsp.config(
            "*",
            ---@type vim.lsp.Config
            {
                capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
            }
        )
    end,
})
