return function()
    MiniDeps.add({
        source = "neovim/nvim-lspconfig",
    })

    -- Function to install LSP servers
    local function install_lsp_servers()
        local servers = {
            gopls = "go install golang.org/x/tools/gopls@latest",
            basedpyright = "npm install -g basedpyright",
            ruff = "brew install ruff", -- ruff includes built-in LSP server
            lua_ls = "brew install lua-language-server",
            yamlls = "npm install -g yaml-language-server",
            helm_ls = "brew install helm-ls",
        }

        vim.ui.select(vim.tbl_keys(servers), {
            prompt = "Select LSP server to install:",
        }, function(choice)
            if not choice then
                return
            end

            local cmd = servers[choice]
            vim.notify("Installing " .. choice .. "...", vim.log.levels.INFO)

            vim.fn.jobstart(cmd, {
                on_exit = function(_, exit_code)
                    if exit_code == 0 then
                        vim.notify(choice .. " installed successfully!", vim.log.levels.INFO)
                    else
                        vim.notify("Failed to install " .. choice .. " (exit code: " .. exit_code .. ")",
                            vim.log.levels.ERROR)
                    end
                end,
                on_stdout = function(_, data)
                    if data then
                        for _, line in ipairs(data) do
                            if line ~= "" then
                                vim.notify(line, vim.log.levels.INFO)
                            end
                        end
                    end
                end,
                on_stderr = function(_, data)
                    if data then
                        for _, line in ipairs(data) do
                            if line ~= "" then
                                vim.notify(line, vim.log.levels.WARN)
                            end
                        end
                    end
                end,
            })
        end)
    end

    -- Create a user command to install LSP servers
    vim.api.nvim_create_user_command("LspInstall", install_lsp_servers, {
        desc = "Install LSP servers manually",
    })

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

    -- Enable LSP servers (must be manually installed)
    -- Install via :LspInstall command defined above
    vim.lsp.enable("gopls")
    vim.lsp.enable("basedpyright")
    vim.lsp.enable("ruff")
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("yamlls")
    vim.lsp.enable("helm_ls")

    -- Ref: https://github.com/theopn/dotfiles/blob/main/nvim/.config/nvim/lua/theovim/lsp.lua
    -- Configuring keymaps and autocmd for LSP buffers
    local lspgroup = vim.api.nvim_create_augroup("nvim.plugins.lsp", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = lspgroup,
        callback = function(event)
            -- get client from event
            -- local client = vim.lsp.get_client_by_id(event.data.client_id)

            local map = function(keys, func, desc, specs)
                local mode = specs and specs.mode or "n"
                local nowait = specs and specs.nowait == true or false
                vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "[LSP] " .. desc, nowait = nowait })
            end

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
