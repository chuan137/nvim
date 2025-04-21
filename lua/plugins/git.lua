local add = MiniDeps.add

local git_specs = {
    "vim-fugitive",
    cmd = { "Git", "GBrowse", "Gvdiffsplit", "Gdiffsplit", "Gvsplit", "Gsplit" },
    before = function()
        add({ source = "tpope/vim-fugitive" })
    end,
}

local keymap = require("lz.n").keymap(git_specs)

keymap.set("n", "<leader>gc", "<Cmd>Git commit<CR>", { desc = "Git Commit" })

return git_specs
