return function()
    MiniDeps.add({ source = "neovim/nvim-lspconfig" })
    MiniDeps.add({ source = "williamboman/mason.nvim" })
    MiniDeps.add({
        source = "williamboman/mason-lspconfig.nvim",
        depends = {"mason.nvim", "nvim-lspconfig"}
    })

    require("mason").setup({})
    require("mason-lspconfig").setup({
        -- automatic_enable = false,
        ensure_installed = {
            "gopls",
            "basedpyright",
            "ruff",
            "lua_ls",
            "yamlls",
            "helm_ls",
            "jsonnet_ls",
        },
    })

    local capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            },
        },
    }

    -- if blin.cmp is installed, enhance capabilities
    pcall(function()
        local blink_cmp = require("blink.cmp")
        capabilities = blink_cmp.get_lsp_capabilities(capabilities)
    end)

    vim.lsp.config("*", { capabilities = capabilities })

    -- Mason will automatically enable installed servers, so no need to manually enable them here.
    -- vim.lsp.enable("gopls")
    -- vim.lsp.enable("basedpyright")
    -- vim.lsp.enable("ruff")
    -- vim.lsp.enable("lua_ls")
    -- vim.lsp.enable("yamlls")
    -- vim.lsp.enable("helm_ls")
    -- vim.lsp.enable("jsonnet_ls")

    vim.opt.completeopt = "menu,menuone,noselect"
    vim.opt.pumheight = 7

    -- Ref: https://github.com/theopn/dotfiles/blob/main/nvim/.config/nvim/lua/theovim/lsp.lua
    -- Configuring keymaps and autocmd for LSP buffers
    local lspgroup = vim.api.nvim_create_augroup("nvim.plugins.lsp", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = lspgroup,
        callback = function(event)
            -- get client from event
            -- local client = vim.lsp.get_client_by_id(event.data.client_id)

            vim.lsp.completion.enable(true, event.data.client_id, event.buf, {
                -- Optional formating of items
                convert = function(item)
                    -- Remove leading misc chars for abbr name,
                    -- and cap field to 25 chars
                    --local abbr = item.label
                    --abbr = abbr:match("[%w_.]+.*") or abbr
                    --abbr = #abbr > 25 and abbr:sub(1, 24) .. "…" or abbr
                    --
                    -- Remove return value
                    --local menu = ""

                    -- Only show abbr name, remove leading misc chars (bullets etc.),
                    -- and cap field to 15 chars
                    local abbr = item.label
                    abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
                    abbr = abbr:match("[%w_.]+.*") or abbr
                    abbr = #abbr > 15 and abbr:sub(1, 14) .. "…" or abbr

                    -- Cap return value field to 15 chars
                    local menu = item.detail or ""
                    menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu

                    return { abbr = abbr, menu = menu }
                end,
            })

            local map = function(keys, func, desc, specs)
                local mode = specs and specs.mode or "n"
                local nowait = specs and specs.nowait == true or false
                vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "[LSP] " .. desc, nowait = nowait })
            end

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

            map("K", function()
                vim.lsp.buf.hover({ border = "rounded" })
            end, "LSP Hover with rounded look")

        end,
    })
end
