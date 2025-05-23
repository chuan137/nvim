-- https://gitlab.com/thomas3081/nvim/-/blob/master/lua/config/lspconfig.lua?ref_type=heads
vim.lsp.enable("gopls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("ruff")
vim.lsp.enable("lua_ls")
-- vim.lsp.enable("yamlls")
vim.lsp.enable("helm_ls")

vim.lsp.config("*", {
    capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            },
        },
    },
})

-- https://gitlab.com/thomas3081/nvim/-/blob/master/lua/config/lspconfig.lua?ref_type=heads
vim.lsp.config("ruff", {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
    init_options = {
        settings = {
            logLevel = "debug",
            lint = {
                select = { "E", "F" },
            },
        },
    },
})

vim.lsp.config(
    "lua_ls",
    ---@type vim.lsp.ClientConfig
    {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath("config")
                    and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        -- Depending on the usage, you might want to add additional paths here.
                        "${3rd}/luv/library",
                        -- "${3rd}/busted/library",
                        vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim",
                        vim.fn.stdpath("data") .. "/site/pack/deps/opt/snacks.nvim",
                    },
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                    -- library = vim.api.nvim_get_runtime_file("", true)
                },
            })
        end,
        settings = {
            Lua = {},
        },
    }
)

vim.lsp.config("basedpyright", {
    settings = {
        basedpyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            analysis = {
                typeCheckingMode = "standard",
            },
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
            },
        },
    },
})

-- Ref: https://github.com/theopn/dotfiles/blob/main/nvim/.config/nvim/lua/theovim/lsp.lua
-- Configuring keymaps and autocmd for LSP buffers
local lspgroup = vim.api.nvim_create_augroup("MyLspAttach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = lspgroup,
    callback = function(event)
        -- Helper function for creating LSP keybindings
        local map = function(keys, func, desc, specs)
            local mode = specs and specs.mode or "n"
            local nowait = specs and specs.nowait == true or false
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "[LSP] " .. desc, nowait = nowait })
        end

        -- settings for the LSP framework
        map("K", function()
            vim.lsp.buf.hover({ border = "rounded" })
        end, "LSP Hover with rounded look")

        -- map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("gd", "<Cmd>lua Snacks.picker.lsp_definitions()<CR>", "Goto Definition")
        map("gD", "<Cmd>lua Snacks.picker.lsp_declarations()<CR>", "Goto Declaration")
        map("gy", "<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>", "Goto T[y]pe Definition")
        map("gri", "<Cmd>lua Snacks.picker.lsp_implementations()<CR>", "Goto Implementation")
        map("grr", "<Cmd>lua Snacks.picker.lsp_references()<CR>", "References", { nowait = true })
        map("gk", "<Cmd>lua Snacks.picker.lsp_symbols()<CR>", "LSP Symbols")
        map("grk", "<Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>", "LSP Workspace Symbols")

        -- map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        -- map("<leader>cr", vim.lsp.buf.rename, "Code Rename")
    end,
})

