local lz = require("lz.n")
local add = MiniDeps.add

local copilot_accept = function()
    local _, copilot = pcall(require, "copilot.suggestion")
    if copilot and copilot.is_visible() then
        copilot.accept()
    end
end

return {
    "blink.cmp",
    before = function()
        add({ source = "saghen/blink.cmp", checkout = "v1.2.0" })
        add({ source = "rafamadriz/friendly-snippets" })
        lz.trigger_load("friendly-snippets")
    end,
    cmd = "BlinkCmp",
    event = { "DeferredUIEnter", "InsertEnter" },
    after = function()
        require("blink.cmp").setup({
            enabled = function()
                return not vim.tbl_contains({ "minifiles" }, vim.bo.filetype)
            end,
            -- https://github.com/Saghen/blink.cmp/discussions/628#discussioncomment-12861317
            keymap = {
                preset = "enter",
                ["<Tab>"] = { "select_next", "snippet_forward", copilot_accept, "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
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
}
