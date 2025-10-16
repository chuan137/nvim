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
    later(require("mini.surround").setup)
else
    vim.cmd("set undodir=~/.cache/vim/undodir")
    vim.cmd([[
        let g:loaded_netrw       = 1
        let g:loaded_netrwPlugin = 1
    ]]) -- disable netrw

    now(function()
        add({ source = "catppuccin/nvim", name = "catppuccin" })
        vim.cmd([[ colorscheme catppuccin-macchiato ]])
        -- vim.cmd("colorscheme retrobox")
    end)

    now(function()
        require("options")
        require("keymaps")
        require("autocmds")
    end)

    -- Load and configure `mini.*` plugins
    now(require("mini.icons").setup)
    now(require("mini.statusline").setup)
    later(require("mini.ai").setup)
    later(require("mini.surround").setup)
    later(require("mini.comment").setup)
    later(require("mini.align").setup)
    later(require("mini.basics").setup)
    later(require("mini.jump").setup)
    later(require("mini.pairs").setup)
    later(require("mini.extra").setup)

    later(function()
        require("mini.notify").setup()
        vim.notify = require("mini.notify").make_notify()
    end)

    later(function()
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
    end)

    -- Load plugins in lua/plugins/*.lua, except files starting with "_"
    -- Plugins listed in `plugin_immediate` are loaded during startup
    local plugins = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/plugins", "*.lua", false, true)

    local plugin_immediate = {
        "lsp",
        "snacks",
        "copilot",
        -- "blink",
    }

    for _, plugin in ipairs(plugins) do
        local plugin_name = plugin:match("plugins/(.+)%.lua$")
        if plugin_name then
            if plugin_name:sub(1, 1) == "_" then
                goto continue
            end
            if vim.tbl_contains(plugin_immediate, plugin_name) then
                now(require("plugins." .. plugin_name))
            else
                later(require("plugins." .. plugin_name))
            end
        end
        ::continue::
    end

    -- Alternative lazy load plugins with 'lz.n'
    -- Example file in plugins/lzn
    --   return {
    --       "which-key.nvim",
    --       before = function()
    --           MiniDeps.add({
    --               source = "folke/which-key.nvim",
    --           })
    --       end,
    --       after = function()
    --           require("which-key").setup()
    --       end,
    --   }
    now(function()
        add({ source = "nvim-neorocks/lz.n" })
        require("lz.n").load("plugins/lzn")
    end)
end
