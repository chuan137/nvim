local map = vim.keymap.set

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("x", "<leader>p", [["_dP]]) -- paste WON'T copy
map("n", "<leader>w", "<C-w>")
map("n", "<leader><Tab>", "<cmd>bnext<cr>")

map("n", "<leader>rp", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>") -- Replace all instance of current word in file
map("v", "<leader>rp", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>") -- Replace all instance of current word in file

map("n", "<leader>up", "<cmd>set paste!<cr>", { desc = "Toggle Paste" })
map("n", "<leader>ul", "<cmd>setlocal spell!<cr>", { desc = "Toggle Spell" })
map("n", "<leader>ug", "<cmd>LazyGit<cr>", { desc = "Git" })

map("n", "Q", "@q")

-- diagnostic
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

-- stylua: ignore start
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- lsp
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
        wk.add({ "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename" })
    end,
})

