return function()
    MiniDeps.add({
        source = "saghen/blink.cmp",
        depends = { "rafamadriz/friendly-snippets" },
        checkout = "v1.2.0",
    })
    require("blink.cmp").setup({
        enabled = function()
            return not vim.tbl_contains({ "minifiles" }, vim.bo.filetype)
        end,
        keymap = {
            preset = "enter",
            -- activate blink

            -- ["<C-y>"] = { "select_and_accept", "fallback" },
            -- ["<C-y>"] = { "select_next", "fallback" },
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
end
