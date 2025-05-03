local M = {}
local add = MiniDeps.add

M.setup = function()
    add({ source = "tpope/vim-fugitive" })
    vim.keymap.set("n", "<leader>gc", "<Cmd>Git commit<CR>", { desc = "Git Commit" })
end

return M
