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
        require('options')
        require('keymaps')

		vim.cmd("set undodir=~/.cache/vim/undodir")
		vim.cmd([[
            let g:loaded_netrw       = 1
            let g:loaded_netrwPlugin = 1
        ]]) -- disable netrw
	end)

    now(function() 
        -- vim.cmd("colorscheme retrobox")
        add({ source = "catppuccin/nvim", name = "catppuccin" })
        vim.cmd[[ colorscheme catppuccin-frappe ]]
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
	later(require("mini.extra").setup)
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
    now(function()
        add({
            source = 'folke/snacks.nvim'
        })
        require("snacks").setup({
            -- bigfile = { enabled = true },
            -- dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            -- scroll = { enabled = true },
            statuscolumn = { enabled = true },
            -- words = { enabled = true },
        })
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function()
                local wk = require('which-key')
                wk.add({ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" })
                wk.add({ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" })
                wk.add({ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" })
                wk.add({ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" })
                wk.add({ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" })
                wk.add({ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" })
                wk.add({ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" })

                -- vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                wk.add({ "<F2>", vim.lsp.buf.rename, desc = "Code Rename" })
                wk.add({ "<F3>", function() vim.lsp.buf.format({async = true}) end, desc = "Code Format" })
            end,
        })
    end)

    later(function()
        add({
            source = 'folke/which-key.nvim'
        })
        local wk = require('which-key')
        wk.setup({
            preset = 'helix',
            -- win = { col = -1, row = 0 }
        })
        wk.add({ "<leader>ue", function() require('snacks').explorer.open({ focus = True }) end,  desc = 'Toggle Explorer' })
    end)

    -- ================ LSP Config ================
	now(function()
        add({ 
            source = 'williamboman/mason-lspconfig.nvim',
            depends = {'williamboman/mason.nvim', 'neovim/nvim-lspconfig'},
        })
        require('mason').setup()
        require('mason-lspconfig').setup()
        vim.lsp.enable('gopls')
        vim.lsp.enable('basedpyright')
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

    later(function()
        add({ source = 'kdheepak/lazygit.nvim' })
    end)

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
