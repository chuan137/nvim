return function()
    MiniDeps.add("christoomey/vim-tmux-navigator")
    vim.keymap.set("n", "<C-S-h>", "<cmd>TmuxNavigateLeft<cr>")
    vim.keymap.set("n", "<C-S-j>", "<cmd>TmuxNavigateDown<cr>")
    vim.keymap.set("n", "<C-S-k>", "<cmd>TmuxNavigateUp<cr>")
    vim.keymap.set("n", "<C-S-l>", "<cmd>TmuxNavigateRight<cr>")
    vim.keymap.set("n", "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>")
end
