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

    -- ///////////////////////////////////////////////////////////////////////

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

    -- ///////////////////////////////////////////////////////////////////////

    -- Plugin loading behavior:
    --   • Loads plugins from lua/plugins/*.lua
    --   • Ignores files starting with "_"
    --   • Plugins in `plugin_immediate` load immediately at startup ("now"), in order
    --   • All other plugins load lazily ("later")
    --   • Uses a compiled plugins cache for faster startup

    local plugin_immediate = {
        -- "blink",
        "lsp",
        "snacks",
        -- "copilot",
        "project",
    }

    -- Try to load compiled plugins
    local compiler = require("plugins-compiler")
    local compiled_plugins = compiler.load_compiled()

    local load_plugin = function(loader, plugin_name)
        -- If we have compiled plugins, use them
        if compiled_plugins and compiled_plugins[plugin_name] then
            loader(compiled_plugins[plugin_name])
        else
            -- Fallback to requiring individual plugin files
            local plugin = require("plugins." .. plugin_name)
            if type(plugin) == "table" and type(plugin.setup) == "function" then
                loader(plugin.setup)
            else
                loader(plugin)
            end
        end
    end

    -- Load plugins listed in `plugin_immediate` immediately at startup, preserving their order
    for _, plugin_name in ipairs(plugin_immediate) do
        load_plugin(now, plugin_name)
    end

    -- Load all other plugins lazily (ignores files starting with "_")
    if compiled_plugins then
        -- Use compiled plugins list
        for plugin_name, _ in pairs(compiled_plugins) do
            if not vim.tbl_contains(plugin_immediate, plugin_name) then
                load_plugin(later, plugin_name)
            end
        end
    else
        -- Fallback to scanning directory
        local plugins = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/plugins", "*.lua", false, true)
        for _, plugin in ipairs(plugins) do
            local plugin_name = plugin:match("plugins/(.+)%.lua$")
            if plugin_name:sub(1, 1) == "_" or vim.tbl_contains(plugin_immediate, plugin_name) then
                goto continue
            end
            load_plugin(later, plugin_name)
            ::continue::
        end
    end

    -- Create command to force recompile plugins
    vim.api.nvim_create_user_command("PluginsRecompile", function()
        compiler.force_recompile()
    end, { desc = "Force recompile plugin cache" })

    -- ///////////////////////////////////////////////////////////////////////

    -- Alternative lazy load plugins in plugins/lzn/*.lua with 'lz.n'

    now(function()
        add({ source = "nvim-neorocks/lz.n" })
        require("lz.n").load("plugins/lzn")
    end)

    -- Example file in plugins/lzn/which_key.lua:
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
end
