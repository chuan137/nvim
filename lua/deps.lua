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
        add({ source = "catppuccin/nvim", name = "catppuccin" })
        vim.cmd([[ colorscheme catppuccin-macchiato ]])
        -- vim.cmd("colorscheme retrobox")
    end)

    -- ================ Mini Plugins ================
    now(require("mini.icons").setup)
    now(require("mini.tabline").setup)
    now(require("mini.statusline").setup)

    now(function()
        require("mini.notify").setup()
        vim.notify = require("mini.notify").make_notify()
    end)

    later(require("mini.ai").setup)
    later(require("mini.surround").setup)
    later(require("mini.comment").setup)
    later(require("mini.pick").setup)
    later(require("mini.align").setup)
    later(require("mini.basics").setup)
    later(require("mini.jump").setup)
    later(require("mini.pairs").setup)
    later(require("mini.extra").setup)

    later(function()
        require("mini.git").setup()

        local rhs = "<Cmd>lua MiniGit.show_at_cursor()<CR>"
        vim.keymap.set({ "n", "x" }, "<leader>gs", rhs, { desc = "Git Show" })

        local diff_folds = "foldmethod=expr foldexpr=v:lua.MiniGit.diff_foldexpr() foldlevel=0"
        vim.cmd("au FileType git,diff setlocal " .. diff_folds)
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

    -- ================ LSP Config ================
    now(function()
        add({
            source = "williamboman/mason-lspconfig.nvim",
            depends = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        })
        require("mason").setup()
        require("mason-lspconfig").setup()
        require("config.lspconfig")
        -- https://gitlab.com/thomas3081/nvim/-/blob/master/lua/config/lspconfig.lua?ref_type=heads
        vim.lsp.enable("gopls")
        vim.lsp.enable("basedpyright")
        vim.lsp.enable("ruff_lsp")
        vim.lsp.enable("lua_ls")
    end)

    -- =============== Conform ================
    later(function()
        add({
            source = "stevearc/conform.nvim",
        })
        require("conform").setup({
            formatters_by_ft = {
                python = { "ruff" },
                lua = { "stylua" },
                json = { "jq" },
                yaml = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                javascript = { "prettier" },
                typescript = { "prettier" },
            },
        })
        vim.keymap.set({ "n", "v" }, "<leader>cf", function()
            require("conform").format({ async = true, lsp_format = "fallback" })
        end, { desc = "Code Format" })
    end)

    -- ================ Treesitter ================
    later(function()
        add({
            source = "nvim-treesitter/nvim-treesitter",
            checkout = "master",
            monitor = "main",
            hooks = {
                post_checkout = function()
                    vim.cmd("TSUpdate")
                end,
            },
        })
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vimdoc", "go", "python" },
            highlight = { enable = true },
        })
    end)

    later(require("plugins.snacks").setup)
    later(require("plugins.blink").setup)
    later(require("plugins.which-key").setup)
    later(require("plugins.copilot").setup)
    later(require("plugins.git").setup)
    -- later(function()
    --     add({ source = "folke/trouble.nvim" })
    --     require("trouble").setup()
    -- end)

    -- ================ Lazy Loading ================
    -- Alternative load plugins with 'lz.n'
    --
    -- now(function()
    --     add({ source = "nvim-neorocks/lz.n" })
    --     require("lz.n").load("plugins/lzn")
    -- end)
    --
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
end
