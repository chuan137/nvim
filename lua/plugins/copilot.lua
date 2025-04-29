return {
    "copilot.lua",
    before = function()
        MiniDeps.add({ source = "zbirenbaum/copilot.lua" })
    end,
    after = function()
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
        vim.keymap.set("i", "<C-h>", function()
            if not copilot.is_visible() then
                copilot.next()
                require("blink.cmp.completion.windows.menu").close()
                -- vim.b.completion = false
            else
                copilot.accept()
            end
        end)
        -- vim.keymap.set("i", "<Tab>", function()
        --     if copilot.is_visible() then
        --         copilot.accept()
        --         -- vim.b.completion = true
        --     else
        --         vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
        --     end
        -- end)
        vim.keymap.set("i", "<C-e>", function()
            if copilot.is_visible() then
                copilot.dismiss()
                vim.b.completion = true
            end
        end)
        -- vim.keymap.set("i", "<C-\\>", function()
        --     if not copilot.is_visible() then
        --         copilot.next()
        --         vim.b.completion = false
        --         require("blink.cmp.completion.windows.menu").close()
        --     else
        --         copilot.accept()
        --         vim.b.completion = true
        --     end
        -- end)
    end,
}
