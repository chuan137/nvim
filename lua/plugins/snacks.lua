return function()
    MiniDeps.add({ source = "folke/snacks.nvim" })
    require("snacks").setup({
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        words = { enabled = true },
        -- statuscolumn = { enabled = true },
        -- notifier = { enabled = true },
        -- bigfile = { enabled = true },
        -- dashboard = { enabled = true },
        -- explorer = { enabled = true },
        -- scroll = { enabled = true },
    })

    -- toggle options
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    Snacks.toggle.dim():map("<leader>uD")
    Snacks.toggle.animate():map("<leader>ua")
    Snacks.toggle.indent():map("<leader>ug")
    Snacks.toggle.scroll():map("<leader>uS")

    local concealLevelOpts =
        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }
    Snacks.toggle.option("conceallevel", concealLevelOpts):map("<leader>uc")

    local showtablineOpts = { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }
    Snacks.toggle.option("showtabline", showtablineOpts):map("<leader>uA")

    if vim.lsp.inlay_hint then
        Snacks.toggle.inlay_hints():map("<leader>uh")
    end

    -- key maps
    local map = vim.keymap.set

    if vim.fn.executable("lazygit") == 1 then
        -- stylua: ignore start
        map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
    end

    local yank_git_url = function()
        Snacks.gitbrowse({
            open = function(url)
                vim.fn.setreg("+", url)
            end,
            notify = false,
        })
    end

    map("n", "<leader>gl", "<Cmd>lua Snacks.picker.git_log_file()<CR>", { desc = "Git File Logs" })
    map("n", "<leader>gL", "<Cmd>lua Snacks.picker.git_log_line()<CR>", { desc = "Git Log Line" })
    map("n", "<leader>gh", "<Cmd>lua Snacks.picker.git_log()<CR>", { desc = "Git Log" })
    map({ "n", "x" }, "<leader>go", "<Cmd>lua Snacks.gitbrowse()<CR>", { desc = "Git Browse (open)" })
    map({ "n", "x" }, "<leader>gY", yank_git_url, { desc = "Git Browse (copy)" })

    map("n", "<leader>?", "<Cmd>lua Snacks.picker.grep({cwd = vim.fn.expand('%:p:h')})<CR>", { desc = "Grep Cwd" })
    map("n", "<leader>/", "<Cmd>lua Snacks.picker.grep()<CR>", { desc = "Grep" })
    map("n", "<leader>o", "<Cmd>lua Snacks.picker.recent()<CR>", { desc = "Recent file" })
    map("n", "<leader>u", "<Cmd>lua Snacks.picker.buffers()<CR>", { desc = "Buffers" })

    map("n", "<leader><cr>", "<Cmd>lua Snacks.picker.resume()<CR>", { desc = "Resume Picker" })
    map("n", "<leader><space>", "<Cmd>lua Snacks.picker.git_files()<CR>", { desc = "Git Files" })
    map("n", "<leader>ff", "<Cmd>lua Snacks.picker.files()<CR>", { desc = "Files" })
    map("n", "<leader>fj", "<Cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Grep Word" })
    map("n", "<leader>fk", "<Cmd>lua Snacks.picker.grep_word({cwd = vim.fn.expand('%:p:h')})<CR>", { desc = "Grep Word Cwd" })
    map("n", "<leader>f/", "<Cmd>lua Snacks.picker.grep_buffers()<CR>", { desc = "Grep Buffers" })

    -- stylua: ignore start
    map("n", "<C-l>", function() Snacks.words.jump(1, true) end, { desc = "Jump to next word" })
    map("n", "<C-h>", function() Snacks.words.jump(-1, true) end, { desc = "Jump to next word" })
    -- stylua: ignore end
end
