return function()
    MiniDeps.add({
        source = "kj-1809/previous-buffer.nvim",
    })

    vim.keymap.set("n", "<leader>E", ":PreviousBuffer<CR>", { silent = true })
end
