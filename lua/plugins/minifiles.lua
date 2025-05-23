return function()
    local mini_files = require("mini.files")
    mini_files.setup({
        mappings = {
            go_in_plus = "<cr>",
        },
    })
    vim.keymap.set("n", "<leader>e", function()
        if mini_files.close() then
            return
        end
        mini_files.open(vim.api.nvim_buf_get_name(0))
    end, { desc = "File explorer" })
end
