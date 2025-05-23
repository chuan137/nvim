local add = MiniDeps.add

return function()
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
    vim.keymap.set("i", "<M-i>", function()
        if not copilot.is_visible() then
            require("blink.cmp.completion.windows.menu").close()
            -- vim.b.completion = false
            copilot.next()
        else
            -- vim.b.completion = true
            copilot.accept()
        end
    end)
end
