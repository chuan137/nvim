return function()
    -- vim-fugitive
    MiniDeps.add({ source = "tpope/vim-fugitive" })
    vim.keymap.set("n", "<leader>gc", "<Cmd>Git commit<CR>", { desc = "Git Commit" })
    vim.keymap.set("n", "<leader>gb", "<Cmd>Git blame<CR>", { desc = "Git blame" })

    -- mini.diff
    require("mini.diff").setup()
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

    -- diffview.nvim
    MiniDeps.add({ source = "sindrets/diffview.nvim", name = "diffview" })

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
