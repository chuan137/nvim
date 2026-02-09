return function()
    MiniDeps.add({ source = "dstein64/vim-startuptime" })
    MiniDeps.add({ source = "google/vim-jsonnet" })

    -- previous-buffer.nvim
    MiniDeps.add({ source = "kj-1809/previous-buffer.nvim" })
    vim.keymap.set("n", "<leader>@", ":PreviousBuffer<CR>")
end
