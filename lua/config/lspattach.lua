-- Ref: https://github.com/theopn/dotfiles/blob/main/nvim/.config/nvim/lua/theovim/lsp.lua
-- Configuring keymaps and autocmd for LSP buffers
local lspgroup = vim.api.nvim_create_augroup("MyLspAttach", { clear = true })
local lspattach = function(event)
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
    -- map("gd", vim.lsp.buf.definition, "Goto Definition")
    -- map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("gd", "<Cmd>lua Snacks.picker.lsp_definitions()<CR>", "Goto Definition")
    map("gI", "<Cmd>lua Snacks.picker.lsp_implementations()<CR>", "Goto Implementation")
    map("gy", "<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>", "Goto T[y]pe Definition")
    map("gr", "<Cmd>lua Snacks.picker.lsp_references()<CR>", "References", { nowait = true })
    map("<leader>gs", "<Cmd>lua Snacks.picker.lsp_symbols()<CR>", "LSP Symbols")
    map("<leader>gS", "<Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>", "LSP Workspace Symbols")
    map("<leader>ga", vim.lsp.buf.code_action, "Code Action")
    map("<leader>gr", vim.lsp.buf.rename, "Code Rename")

    -- Symbol highlights
    -- Creates an autocmd to highlight the symbol under the cursor
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local my_lsp_hl_group = vim.api.nvim_create_augroup("MyLspHl", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = my_lsp_hl_group,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = my_lsp_hl_group,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("MyLspHlDetach", { clear = true }),
            callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = my_lsp_hl_group, buffer = event2.buf })
            end,
        })
    end

    -- Integration with the built-in completion
    if client and client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, event.buf, {
            autotrigger = true,
            -- convert = function(item)
            --   return { abbr = item.label:gsub("%b()", "") }
            -- end,
        })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = lspgroup,
    callback = lspattach,
})
