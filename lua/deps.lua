-- Bootstrap mini.deps
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/echasnovski/mini.nvim",
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Setup mini.deps
require("mini.deps").setup({ path = { package = path_package } })

-- Load other plugins
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

if vim.fn.exists("g:vscode") ~= 0 then
    now(function()
        -- Vim in VSCode
    end)

    later(require("mini.ai").setup)
    later(require("mini.comment").setup)
    later(require("mini.surround").setup)
    return
end

vim.cmd([[
        set background=light
        colorscheme randomhue
    ]])
vim.cmd([[
        let g:loaded_netrw       = 1
        let g:loaded_netrwPlugin = 1
    ]]) -- disable netrw

now(function()
    require("options")
    require("keymaps")
    require("autocmds")
end)

now(require("plugins.lsp"))
later(require("plugins.conform"))
later(require("plugins.treesitter"))

now(require("mini.statusline").setup)
now(require("mini.icons").setup)
now(require("mini.tabline").setup)
-- now(require("plugins.notify"))

later(require("mini.ai").setup)
later(require("mini.comment").setup)
later(require("mini.surround").setup)
later(require("plugins.minifiles"))

later(function()
    require("mini.misc").setup()
    MiniMisc.setup_auto_root()
end)

-- ======= Continue for more =======================================

if vim.g.minimal then
    return
end

now(function()
    -- add({ source = "catppuccin/nvim", name = "catppuccin" })
    -- vim.cmd([[ colorscheme catppuccin-latte ]])
    vim.cmd([[
        set background=dark
        colorscheme retrobox
        ]])
end)

-- ================ Mini Plugins ================

later(require("mini.align").setup)
later(require("mini.basics").setup)
later(require("mini.jump").setup)
later(require("mini.pairs").setup)
-- later(require("mini.pick").setup)
-- later(require("mini.extra").setup)

later(function()
end)

-- =============== Conform ================

later(require("plugins.blink"))
later(require("plugins.copilot"))
later(require("plugins.copilotchat"))
later(require("plugins.git"))
later(require("plugins.snacks"))
later(require("plugins.trouble"))
later(require("plugins.which-key"))

-- ================ Lazy Loading ================
-- Alternative load plugins with 'lz.n'
now(function()
    add({ source = "nvim-neorocks/lz.n" })
    require("lz.n").load("plugins/lzn")
end)

-- Example file in plugins/lzn
-- return {
--     "which-key.nvim",
--     before = function()
--         deps.add({
--             source = "folke/which-key.nvim",
--         })
--     end,
--     after = function()
--         require("which-key").setup()
--     end,
-- }
