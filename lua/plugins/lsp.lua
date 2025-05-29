return function()
    MiniDeps.add({
        source = "williamboman/mason-lspconfig.nvim",
        depends = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    })

    require("mason").setup()
    require("mason-lspconfig").setup()

    local capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            },
        },
    }
    vim.lsp.config("*", { capabilities = capabilities })

    -- require("plugins.blink")
    -- vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(capabilities) })

    -- https://gitlab.com/thomas3081/nvim/-/blob/master/lua/config/lspconfig.lua?ref_type=heads
    vim.lsp.enable("gopls")
    vim.lsp.enable("basedpyright")
    vim.lsp.enable("ruff")
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("yamlls")
    vim.lsp.enable("helm_ls")

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
            map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
            map("<leader>cr", vim.lsp.buf.rename, "Code Rename")
        end,
    })
end
