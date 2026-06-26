return function()
    MiniDeps.add({ source = "zbirenbaum/copilot.lua" })
    require("copilot").setup({
        panel = { enabled = false },
        suggestion = {
            auto_trigger = true,
            hide_during_completion = true,
            debounce = 75,
            keymap = {
                accept = "<C-l>",
                accept_word = "<M-w>",
                accept_line = "<M-l>",
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-/>",
            },
        },
        filetypes = {
            yaml = true,
            markdown = true,
            help = false,
            gitcommit = true,
            gitrebase = false,
            hgcommit = true,
            svn = true,
            cvs = true,
            ["."] = true,
        },
        server_opts_overrides = {},
    })

    -- local copilot = require("copilot.suggestion")
    --
    -- vim.keymap.set("i", "<C-e>", function()
    --     if copilot.is_visible() then
    --         return
    --         -- copilot.accept()
    --     else
    --         vim.b.copilot_suggestion_hidden = false
    --         copilot.next()
    --     end
    -- end)
    --
    -- vim.api.nvim_create_autocmd("User", {
    --     pattern = "BlinkCmpMenuOpen",
    --     callback = function()
    --         vim.b.copilot_suggestion_hidden = true
    --         copilot.dismiss()
    --     end,
    -- })
    --
    -- vim.api.nvim_create_autocmd("User", {
    --     pattern = "BlinkCmpMenuClose",
    --     callback = function()
    --         vim.b.copilot_suggestion_hidden = false
    --         copilot.next()
    --     end,
    -- })
end
