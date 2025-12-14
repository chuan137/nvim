return function()
    MiniDeps.add({
        source = "saghen/blink.cmp",
        depends = { "rafamadriz/friendly-snippets" },
        checkout = "v1.3.0",
    })
    require("blink.cmp").setup({
        enabled = function()
            return not vim.tbl_contains({ "minifiles" }, vim.bo.filetype)
        end,
        keymap = {
            -- preset = "enter",
            ["<CR>"] = { "accept", "fallback" },
            ["<C-\\>"] = { "hide", "fallback" },
            ["<C-n>"] = { "select_next", "show" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<C-p>"] = { "select_prev" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },

            -- ["<C-y>"] = {
            --     "cancel",
            --     function()
            --         if require("copilot.suggestion").is_visible() then
            --             require("copilot.suggestion").accept()
            --             return
            --         end
            --     end,
            --     "fallback",
            -- },
        },
        appearance = { nerd_font_variant = "mono" },
        completion = {
            documentation = {
                auto_show = true,
                window = { border = "rounded" },
            },
            menu = {
                border = "rounded",
                scrollbar = false,
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = {
            enabled = true,
        },
    })
    -- vim.lsp.config("*", {
    --     capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
    --     -- capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
    -- })
end
