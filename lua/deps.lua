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
    -- Safely execute immediately
    now(function()
        require("config.options")
        require("config.keymaps")
        require("config.commands")

        vim.cmd("set undodir=~/.cache/vim/undodir")
        vim.cmd([[
            let g:loaded_netrw       = 1
            let g:loaded_netrwPlugin = 1
        ]]) -- disable netrw
    end)

    now(function()
        -- vim.cmd("colorscheme retrobox")
        add({ source = "catppuccin/nvim", name = "catppuccin" })
        vim.cmd([[ colorscheme catppuccin-macchiato ]])
    end)

    -- ================ Mini Plugins ================
    now(require("mini.icons").setup)
    now(require("mini.tabline").setup)
    now(require("mini.statusline").setup)

    later(require("mini.ai").setup)
    later(require("mini.surround").setup)
    later(require("mini.basics").setup)
    later(require("mini.diff").setup)
    later(require("mini.pairs").setup)
    later(require("mini.comment").setup)
    -- later(require("mini.pick").setup)
    -- later(require("mini.align").setup)
    -- later(require("mini.cursorword").setup)
    -- later(require("mini.jump").setup)
    -- later(require("mini.extra").setup)

    -- now(function()
    --     require("mini.notify").setup()
    --     vim.notify = require("mini.notify").make_notify()
    -- end)

    -- later(function()
    --     require("mini.git").setup()
    --
    --     local rhs = "<Cmd>lua MiniGit.show_at_cursor()<CR>"
    --     vim.keymap.set({ "n", "x" }, "<leader>gs", rhs, { desc = "Git Show" })
    --
    --     local diff_folds = "foldmethod=expr foldexpr=v:lua.MiniGit.diff_foldexpr() foldlevel=0"
    --     vim.cmd("au FileType git,diff setlocal " .. diff_folds)
    -- end)

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

    -- ================ LSP Config ================
    now(function()
        add({
            source = "williamboman/mason-lspconfig.nvim",
            depends = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        })
        require("mason").setup()
        require("mason-lspconfig").setup()
        -- local lspconfig = require("lspconfig")
        require("config/lspconfig")

        vim.lsp.enable("gopls")
        vim.lsp.enable("basedpyright")
        vim.lsp.enable("ruff")
        vim.lsp.enable("lua_ls")
    end)

    -- ================ Folke ================
    later(function()
        add({
            source = "folke/which-key.nvim",
        })
        local wk = require("which-key")
        wk.setup({
            preset = "helix",
        })
    end)

    later(function()
        add({
            source = "folke/snacks.nvim",
        })
        require("snacks").setup({
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            statuscolumn = { enabled = true },
            -- bigfile = { enabled = true },
            -- dashboard = { enabled = true },
            -- explorer = { enabled = true },
            -- scroll = { enabled = true },
            -- words = { enabled = true },
        })
        require("config.pickers")
    end)

    -- ================ Copilot ================
    later(function()
        add({ source = "zbirenbaum/copilot.lua" })
        require("copilot").setup({
            panel = {
                enabled = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = false,
                debounce = 75,
                keymap = {
                    -- accept = "<Tab>",
                    accept_word = "<M-w>",
                    accept_line = "<M-e>",
                    dismiss = false,
                    next = "<M-]>",
                    prev = false,
                },
            },
            filetypes = {
                yaml = true,
                markdown = true,
                help = true,
                gitcommit = true,
                gitrebase = true,
                hgcommit = true,
                svn = true,
                cvs = true,
                ["."] = true,
            },
            server_opts_overrides = {},
        })
        local copilot = require("copilot.suggestion")
        vim.keymap.set("i", "<C-Space>", function()
            if not copilot.is_visible() then
                copilot.next()
                require("blink.cmp.completion.windows.menu").close()
                -- vim.b.completion = false
            end
        end)
        vim.keymap.set("i", "<Tab>", function()
            if copilot.is_visible() then
                copilot.accept()
                -- vim.b.completion = true
            end
        end)
        vim.keymap.set("i", "<C-e>", function()
            if copilot.is_visible() then
                copilot.dismiss()
                vim.b.completion = true
            end
        end)
        -- vim.keymap.set("i", "<C-\\>", function()
        --     if not copilot.is_visible() then
        --         copilot.next()
        --         vim.b.completion = false
        --         require("blink.cmp.completion.windows.menu").close()
        --     else
        --         copilot.accept()
        --         vim.b.completion = true
        --     end
        -- end)
    end)

    -- ================ Lazy Loading ================
    -- Alternative load plugins with 'lz.n'
    --
    add({ source = "nvim-neorocks/lz.n" })
    require("lz.n").load("plugins")

    --
    -- Example file in plugins/
    -- return {
    --     'which-key.nvim',
    -- 	before = function()
    -- 		deps.add({
    --             source = 'folke/which-key.nvim',
    -- 		})
    -- 	end,
    --     after = function()
    --         require('which-key').setup()
    --     end,
    -- }
end
