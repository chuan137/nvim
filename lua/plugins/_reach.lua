return function()
    MiniDeps.add({ source = "toppair/reach.nvim" })

    -- require('reach').buffers()
    vim.keymap.set("n", "<leader>]", function()
        require("reach").buffers()
    end, {})
end
