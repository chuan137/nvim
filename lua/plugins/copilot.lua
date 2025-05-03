local M = {}
local add = MiniDeps.add

M.setup = function()
    add({ source = "zbirenbaum/copilot.lua" })
    require("copilot").setup({
        panel = {
            enabled = false,
        },
        suggestion = {
            enabled = true,
            auto_trigger = false,
            debounce = 75,
            keymap = {
                -- accept = "<Tab>",
                accept_word = "<M-w>",
                accept_line = "<M-e>",
                dismiss = false,
                next = "<M-]>",
                prev = false,
            },
        },
        filetypes = {
            yaml = true,
            markdown = true,
            help = true,
            gitcommit = true,
            gitrebase = true,
            hgcommit = true,
            svn = true,
            cvs = true,
            ["."] = true,
        },
        server_opts_overrides = {},
    })
    local copilot = require("copilot.suggestion")
    vim.keymap.set("i", "<C-e>", function()
        if copilot.is_visible() then
            copilot.dismiss()
            vim.b.completion = true
        end
    end)
    vim.keymap.set("i", "<C-y>", function()
        if not copilot.is_visible() then
            copilot.next()
            vim.b.completion = false
            require("blink.cmp.completion.windows.menu").close()
        end
        if copilot.is_visible() then
            copilot.accept()
            vim.b.completion = true
        end
    end)
end

return M
