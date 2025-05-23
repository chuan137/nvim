return function()
    MiniDeps.add({ source = "tpope/vim-fugitive" })
    vim.keymap.set("n", "<leader>gc", "<Cmd>Git commit<CR>", { desc = "Git Commit" })

    require("mini.diff").setup()
    require("mini.git").setup()

    local rhs = "<Cmd>lua MiniGit.show_at_cursor()<CR>"
    vim.keymap.set({ "n", "x" }, "<leader>gs", rhs, { desc = "Git Show" })

    local diff_folds = "foldmethod=expr foldexpr=v:lua.MiniGit.diff_foldexpr() foldlevel=0"
    vim.cmd("au FileType git,diff setlocal " .. diff_folds)

    rhs = "<Cmd>lua MiniDiff.toggle_overlay()<CR>"
    vim.keymap.set("n", "<leader>gv", rhs, { desc = "Git diff o[v]erlay" })
end
