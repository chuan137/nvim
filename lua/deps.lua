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
        require("options")
        require("keymaps")
        require("commands")

        vim.cmd("set undodir=~/.cache/vim/undodir")
        vim.cmd([[
            let g:loaded_netrw       = 1
            let g:loaded_netrwPlugin = 1
        ]]) -- disable netrw
    end)

    now(function()
        -- vim.cmd("colorscheme retrobox")
        add({ source = "catppuccin/nvim", name = "catppuccin" })
        vim.cmd([[ colorscheme catppuccin-frappe ]])
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
    later(require("mini.cursorword").setup)
    later(require("mini.jump").setup)
    later(require("mini.pairs").setup)
    later(require("mini.diff").setup)
    later(require("mini.extra").setup)

    later(function()
        require("mini.git").setup()

        local rhs = '<Cmd>lua MiniGit.show_at_cursor()<CR>'
        vim.keymap.set({ "n", "x" }, "<leader>gs", rhs, { desc = "Git Show" })

        local diff_folds = 'foldmethod=expr foldexpr=v:lua.MiniGit.diff_foldexpr() foldlevel=0'
        vim.cmd('au FileType git,diff setlocal ' .. diff_folds)
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

    -- ================ Folke ================
    later(function()
        add({
            source = "folke/which-key.nvim",
        })
        local wk = require("which-key")
        wk.setup({
            preset = "helix",
            -- win = { col = -1, row = 0 }
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

		-- toggle options
		-- stylua: ignore start
		Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
		Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
		Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
		Snacks.toggle.diagnostics():map("<leader>ud")
		Snacks.toggle.line_number():map("<leader>ul")
		Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
		Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
		Snacks.toggle.treesitter():map("<leader>uT")
		Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
		Snacks.toggle.dim():map("<leader>uD")
		Snacks.toggle.animate():map("<leader>ua")
		Snacks.toggle.indent():map("<leader>ug")
		Snacks.toggle.scroll():map("<leader>uS")
        -- Snacks.toggle.profiler():map("<leader>dpp")
        -- Snacks.toggle.profiler_highlights():map("<leader>dph")

        if vim.lsp.inlay_hint then
            Snacks.toggle.inlay_hints():map("<leader>uh")
        end

        local map = vim.keymap.set

        local get_git_root = function()
            local cwd = vim.fn.expand('%:p:h')
            local root = vim.fn.systemlist("git -C " .. cwd .." rev-parse --show-toplevel")[1]
            return root
        end

        if vim.fn.executable("lazygit") == 1 then
            map("n", "<leader>gg", function() Snacks.lazygit( { cwd = get_git_root() }) end, { desc = "Lazygit (Root Dir)" })
            map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
            map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
            map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Git Log" })
            map("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
        end

        map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
        map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
        map({"n", "x" }, "<leader>gY", function()
            Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
        end, { desc = "Git Browse (copy)" })

        -- vim.keymap.set("n", "<leader>ue", function()
        --     require("snacks").explorer.open({ focus = True })
        -- end, { desc = "Toggle Explorer" })
    end)

    -- ================ LSP Config ================
    now(function()
        add({
            source = "williamboman/mason-lspconfig.nvim",
            depends = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        })
        require("mason").setup()
        require("mason-lspconfig").setup()
        local lspconfig = require("lspconfig")
        -- https://gitlab.com/thomas3081/nvim/-/blob/master/lua/config/lspconfig.lua?ref_type=heads
        vim.lsp.config("*", {
            root_markers = {
                ".git",
                "Makefile",
                "package.json",
                "Cargo.toml",
                "pyproject.toml",
            },
        })
        vim.lsp.enable("gopls")
        vim.lsp.enable("basedpyright")
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
        end, { desc = "Format" })
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

    -- ================ Blink.cmp ================
    later(function()
        add({
            source = "saghen/blink.cmp",
            depends = { "rafamadriz/friendly-snippets" },
            -- hooks = {
            --     post_checkout = function()
            --         local blinkpath = vim.fn.stdpath("data") .. "/site/pack/deps/opt/blink.cmp"
            --         require('mini.notify').info("Downloading Blink.cmp to " .. blinkpath)
            --         vim.fn.system({
            --             "curl",
            --             "-s",
            --             "--create-dirs",
            --             "--output",
            --             vim.fn.stdpath("data") .. "/site/pack/deps/opt/blink.cmp" .. "/target/release/libblink_cmp_fuzzy.dylib",
            --             "https://github.com/saghen/blink.cmp/releases/latest/download/aarch64-apple-darwin.dylib",
            --         })
            --     end,
            -- },
        })
        require("blink.cmp").setup({
            keymap = {
                preset = "enter",
                ["<C-y"] = { "select_and_accept" },
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = { documentation = { auto_show = false } },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        })
        vim.lsp.config(
            "*",
            ---@type vim.lsp.Config
            {
                capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
            }
        )
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
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<Tab>",
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
        vim.keymap.set("i", "<C-e>", function()
            if copilot.is_visible() then
                copilot.dismiss()
            end
        end)
    end)

    -- ================ Lazy Loading ================
    -- Alternative load plugins with 'lz.n'
    --
    -- add({ source = "nvim-neorocks/lz.n" })
    -- require('lz.n').load 'plugins'
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
