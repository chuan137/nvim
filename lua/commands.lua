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

local copilot_installed, _ = pcall(require, "copilot.suggestion")
local togle_copilot_suggestion = vim.api.nvim_create_augroup("chuan137/toggle_copilot_suggestion", {})
vim.api.nvim_create_autocmd("User", {
    group = togle_copilot_suggestion,
    desc = "Dismiss copilot suggestion on blink completion menu open",
    pattern = "BlinkCmpMenuOpen",
    callback = function()
        if copilot_installed then
            require("copilot.suggestion").dismiss()
            vim.b.copilot_suggestion_hidden = true
        end
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

-- vim.api.nvim_create_autocmd('FocusLost', {
--     desc = "Copy to clipboard on FocusLost",
--     callback = function()
--         vim.fn.setreg("+", vim.fn.getreg("0"))
--     end,
-- })

vim.api.nvim_create_user_command("CdCurrent", function()
    local dir = vim.fn.expand("%:p:h")
    if dir ~= "" then
        -- find the nearest .git directory and set that as the CWD
        local git_dir = vim.fn.finddir(".git", dir .. ";")
        if git_dir ~= "" then
            dir = vim.fn.fnamemodify(git_dir, ":h")
        end
        vim.api.nvim_set_current_dir(dir)
        print("CWD changed to: " .. dir)
    else
        print("Buffer has no file path.")
    end
end, { desc = "Change CWD to current buffer's directory" })

local function get_project_relative_path()
    local filepath = vim.fn.expand("%:p")
    local filedir = vim.fn.fnamemodify(filepath, ":h")
    local git_root = vim.fn.systemlist({ "git", "-C", filedir, "rev-parse", "--show-toplevel" })[1]

    if vim.v.shell_error == 0 and git_root and git_root ~= "" then
        return vim.fs.relpath(git_root, filepath) or filepath
    end

    return vim.fn.expand("%")
end

local function get_ai_location(opts)
    local filepath = get_project_relative_path()
    local start_line = opts.line1
    local end_line = opts.line2

    return start_line == end_line and filepath .. ":" .. start_line or filepath .. ":" .. start_line .. "-" .. end_line
end

vim.api.nvim_create_user_command("YankAI", function(opts)
    local location = get_ai_location(opts)
    local lines = vim.fn.getline(opts.line1, opts.line2)
    local code = table.concat(lines, "\n")

    vim.fn.setreg("+", location .. "\n\n" .. code)
    print("📋 " .. location)
end, { range = true })

vim.api.nvim_create_user_command("YankAIPath", function(opts)
    local location = get_ai_location(opts)

    vim.fn.setreg("+", location)
    print("📋 " .. location)
end, { range = true })

vim.keymap.set("n", "<leader>gY", ":YankAI<CR>", { desc = "Yank code context for AI" })
vim.keymap.set("v", "<leader>gY", ":YankAI<CR>", { desc = "Yank code context for AI" })
vim.keymap.set("n", "<leader>gP", ":YankAIPath<CR>", { desc = "Yank path context for AI" })
vim.keymap.set("v", "<leader>gP", ":YankAIPath<CR>", { desc = "Yank path context for AI" })
