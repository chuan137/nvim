local function configCodeDiff()
    MiniDeps.add({ source = "esmuellert/codediff.nvim" })

    require("codediff").setup({
        diff = {
            layout = "side-by-side",
            disable_inlay_hints = true,
            cycle_next_hunk = true,
            cycle_next_file = true,
        },
        explorer = {
            position = "left",
            width = 40,
            initial_focus = "explorer",
            view_mode = "tree",
            focus_on_select = false,
        },
        history = {
            position = "bottom",
            height = 15,
            initial_focus = "history",
            view_mode = "list",
        },
    })

    vim.keymap.set("n", "<leader>gd", "<Cmd>CodeDiff<CR>", { desc = "Git CodeDiff" })
    vim.keymap.set("n", "<leader>gD", "<Cmd>CodeDiff main...<CR>", { desc = "Git CodeDiff main" })
    vim.keymap.set("n", "<leader>gf", "<Cmd>CodeDiff file HEAD<CR>", { desc = "Git CodeDiff File" })
    vim.keymap.set("n", "<leader>gh", "<Cmd>CodeDiff history<CR>", { desc = "Git CodeDiff History" })
    vim.keymap.set("n", "<leader>gp", "<Cmd>CodeDiff HEAD~<CR>", { desc = "Git CodeDiff previous" })
    vim.keymap.set("n", "<leader>ge", function()
        local lifecycle = require("codediff.ui.lifecycle")
        local tabpage = vim.api.nvim_get_current_tabpage()
        local history = lifecycle.get_explorer(tabpage)
        if not history or not history.tree then
            vim.notify("No codediff history panel open", vim.log.levels.WARN)
            return
        end
        local node = history.tree:get_node()
        if not node or not node.data or node.data.type ~= "commit" then
            vim.notify("No commit selected", vim.log.levels.WARN)
            return
        end
        local hash = node.data.hash
        vim.cmd("tabnew")
        vim.api.nvim_cmd({ cmd = "CodeDiff", args = { hash .. "^", hash } }, {})
    end, { desc = "Git CodeDiff enter commit" })
end

local function configDiffView()
    MiniDeps.add({
        source = "sindrets/diffview.nvim",
        name = "diffview",
        depends = { "nvim-tree/nvim-web-devicons" },
    })

    local function toggle_diffview(cmd)
        if next(require("diffview.lib").views) == nil then
            vim.cmd(cmd)
        else
            vim.cmd("DiffviewClose")
        end
    end

    vim.keymap.set("n", "<leader>gd", function()
        toggle_diffview("DiffviewOpen")
    end, { desc = "Git Diffview Index" })

    vim.keymap.set("n", "<leader>gD", function()
        toggle_diffview("DiffviewOpen main..HEAD")
    end, { desc = "Git Diffview master" })

    vim.keymap.set("n", "<leader>gf", function()
        toggle_diffview("DiffviewFileHistory %")
    end, { desc = "Git Diffview File" })

    vim.keymap.set("n", "<leader>gq", "<Cmd>DiffviewClose<CR>", { desc = "Git Diffview Close" })
end

return function()
    -- vim-fugitive
    MiniDeps.add({ source = "tpope/vim-fugitive" })
    vim.keymap.set("n", "<leader>gc", "<Cmd>Git commit<CR>", { desc = "Git Commit" })
    vim.keymap.set("n", "<leader>gb", "<Cmd>Git blame<CR>", { desc = "Git blame" })

    -- mini.diff
    require("mini.diff").setup({
        mappings = {
            -- Apply hunks inside a visual/operator region
            apply = "gh",

            -- Reset hunks inside a visual/operator region
            reset = "gH",

            -- Hunk range textobject to be used inside operator
            -- Works also in Visual mode if mapping differs from apply and reset
            textobject = "gh",

            -- Go to hunk range in corresponding direction
            goto_first = "[C",
            goto_prev = "[c",
            goto_next = "]c",
            goto_last = "]C",
        },
    })
    local rhs = "<Cmd>lua MiniDiff.toggle_overlay()<CR>"
    vim.keymap.set("n", "<leader>gv", rhs, { desc = "Git diff o[v]erlay" })

    -- mini.git
    -- require("mini.git").setup()
    --
    -- local rhs = "<Cmd>lua MiniGit.show_at_cursor()<CR>"
    -- vim.keymap.set({ "n", "x" }, "<leader>gs", rhs, { desc = "Git Show" })
    --
    -- local diff_folds = "foldmethod=expr foldexpr=v:lua.MiniGit.diff_foldexpr() foldlevel=0"
    -- vim.cmd("au FileType git,diff setlocal " .. diff_folds)

    configCodeDiff()
    -- configDiffView()
end
