return function()
    MiniDeps.add({ source = "folke/snacks.nvim" })
    require("snacks").setup({
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        words = { enabled = true },
        terminal = { enabled = true },
        statuscolumn = { enabled = true },
        -- notifier = { enabled = true },
        -- bigfile = { enabled = true },
        -- dashboard = { enabled = true },
        -- explorer = { enabled = true },
        -- scroll = { enabled = true },

        gitbrowse = {
            url_patterns = {
                ["github%.corp"] = {
                    branch = "/tree/{branch}",
                    file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                    permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
                    commit = "/commit/{commit}",
                },
            },
        },
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

    local yank_git_url = function()
        Snacks.gitbrowse({
            open = function(url)
                vim.fn.setreg("+", url)
            end,
            notify = false,
        })
    end

    local keys = {
        -- stylua: ignore start
        --  top pickers 
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader><cr>", function() Snacks.picker.resume() end, desc = "Resume Picker" },
        { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>?", function() Snacks.picker.grep({cwd = vim.fn.expand('%:p:h')}) end,  desc = "Grep Cwd" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>o", function() Snacks.picker.recent() end, desc = "Recent" },
        { "<leader>k", function() Snacks.picker.grep_word() end, desc = "Grep Word", mode = { "n", "x" } },
        { "<leader>K", function() Snacks.picker.grep_word({cwd = vim.fn.expand('%:p:h')}) end, desc = "Grep Word Cwd" },
        -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
        -- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
        -- find
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        -- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        -- Grep
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit (cwd)" },
        { "<leader>go", function() Snacks.gitbrowse() end, desc = "Git Browse (open)" },
        { "<leader>gy", function() yank_git_url() end, desc = "Git Browse (copy)",  mode = {"n", "x" } },
        -- others
        { "<leader><backspace>", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<c-_>", function() Snacks.terminal() end, desc = "Toggle Terminal", mode = {"n", "t"} },
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    }

    require("utils").register_keys(keys)
end
