vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("chuan137/last_location", {}),
    desc = "Go to the last location when opening a buffer",
    callback = function(args)
        local exclude = { "gitcommit" }
        if vim.tbl_contains(exclude, vim.bo[args.buf].filetype) or vim.b[args.buf].chuan137_last_loc then
            return
        end
        vim.b[args.buf].chuan137_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"zz')
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("chuan137/close_with_q", {}),
    desc = "Close with <q>",
    pattern = {
        "checkhealth",
        "dbout",
        "git",
        "gitsigns-blame",
        "grug-far",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "startuptime",
    },
    callback = function(args)
        vim.keymap.set("n", "q", "<cmd>bwipeout<cr>", { buffer = args.buf })
    end,
})

local togle_copilot_suggestion = vim.api.nvim_create_augroup("chuan137/toggle_copilot_suggestion", {})
vim.api.nvim_create_autocmd("User", {
    group = togle_copilot_suggestion,
    desc = "Dismiss copilot suggestion on blink completion menu open",
    pattern = "BlinkCmpMenuOpen",
    callback = function()
        require("copilot.suggestion").dismiss()
        vim.b.copilot_suggestion_hidden = true
    end,
})
vim.api.nvim_create_autocmd("User", {
    group = togle_copilot_suggestion,
    desc = "Show copilot suggestion on blink completion menu closed",
    pattern = "BlinkCmpMenuClose",
    callback = function()
        vim.b.copilot_suggestion_hidden = false
    end,
})

local line_numbers_group = vim.api.nvim_create_augroup("chuan137/toggle_line_numbers", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
    group = line_numbers_group,
    desc = "Toggle relative line numbers on",
    callback = function()
        if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, "i") then
            vim.wo.relativenumber = true
        end
    end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
    group = line_numbers_group,
    desc = "Toggle relative line numbers off",
    callback = function(args)
        if vim.wo.nu then
            vim.wo.relativenumber = false
        end

        -- Redraw here to avoid having to first write something for the line numbers to update.
        if args.event == "CmdlineEnter" then
            if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
                vim.cmd.redraw()
            end
        end
    end,
})
