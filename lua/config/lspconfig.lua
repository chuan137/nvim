-- https://gitlab.com/thomas3081/nvim/-/blob/master/lua/config/lspconfig.lua?ref_type=heads

vim.lsp.config(
    "*",

    ---@type vim.lsp.ClientConfig
    {
        on_attach = function(client, bufnr)
            local map = vim.keymap.set
            -- vim.keymap.set("n", "gd", "<Cmd>lua Snacks.picker.lsp_definitions()<CR>", { desc = "Goto Definition" })
            -- vim.keymap.set("n", "gD", "<Cmd>lua Snacks.picker.lsp_declarations()<CR>", { desc = "Goto Declaration" })
            map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
            map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
            map("n", "gr", "<Cmd>lua Snacks.picker.lsp_references()<CR>", { nowait = true, desc = "References" })
            map("n", "gI", "<Cmd>lua Snacks.picker.lsp_implementations()<CR>", { desc = "Goto Implementation" })
            map("n", "gy", "<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>", { desc = "Goto T[y]pe Definition" })
            map("n", "<leader>ss", "<Cmd>lua Snacks.picker.lsp_symbols()<CR>", { desc = "LSP Symbols" })
            map(
                "n",
                "<leader>sS",
                "<Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>",
                { desc = "LSP Workspace Symbols" }
            )
            map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
            map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code Rename" })
        end,
    }
)

vim.lsp.config("ruff", {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
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
