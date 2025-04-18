-- https://gitlab.com/thomas3081/nvim/-/blob/master/lua/config/lspconfig.lua?ref_type=heads

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
                        vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim',
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
