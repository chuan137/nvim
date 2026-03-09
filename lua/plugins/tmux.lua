return function()
    MiniDeps.add("christoomey/vim-tmux-navigator")
    vim.keymap.set("n", "<A-Left>", "<cmd>TmuxNavigateLeft<cr>", { silent = true })
    vim.keymap.set("n", "<A-Down>", "<cmd>TmuxNavigateDown<cr>", { silent = true })
    vim.keymap.set("n", "<A-Up>", "<cmd>TmuxNavigateUp<cr>", { silent = true })
    vim.keymap.set("n", "<A-Right>", "<cmd>TmuxNavigateRight<cr>", { silent = true })
    vim.keymap.set("n", "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>")
end
