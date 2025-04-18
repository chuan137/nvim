return {
    "nvim-treesitter",
    event = "DeferredUIEnter",
    before = function()
        MiniDeps.add({
            source = "nvim-treesitter/nvim-treesitter",
            checkout = "master",
            monitor = "main",
            hooks = {
                post_checkout = function()
                    vim.cmd("TSUpdate")
                end,
            },
        })
    end,
    after = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vimdoc", "go", "python" },
            highlight = { enable = false },
        })
        -- use <C-L> in insert mode to jump to end of current treesitter node
        -- https://github.com/santhosh-tekuri/dotfiles/blob/master/nvim/lua/insjump.lua
        vim.keymap.set("i", "<C-L>", function()
            local node = vim.treesitter.get_node()
            if node ~= nil then
                local row, col = node:end_()
                pcall(vim.api.nvim_win_set_cursor, 0, { row + 1, col })
            end
        end, { desc = "insjump" })
    end,
}
