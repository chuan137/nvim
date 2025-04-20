local map = vim.keymap.set

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "Q", "@q")

-- map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("n", "<leader>w", "<C-w>")

map("n", "<leader>rp", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>") -- Replace all instance of current word in file
map("v", "<leader>rp", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>") -- Replace all instance of current word in file

-- move current line up/down
map("n", "<M-j>", ":m .+1<CR>==")
map("n", "<M-k>", ":m .-2<CR>==")

-- move selected lines up/down
map("v", "<M-j>", ":m '>+1<CR>gv=gv")
map("v", "<M-k>", ":m '<-2<CR>gv=gv")

-- system clipboard
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = "Copy to system clipboard" })
-- vim.keymap.set('n', '<leader>Y', '"+Y', { desc = "Copy to system clipboard" })
-- vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = "Paste clipboard after selection" })
-- vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = "Paste clipboard before selection" })
map("x", "<leader>p", [["_dP]]) -- paste WON'T copy

-- retain selection after indent ('gv' highlights previous selection)
-- map("v", ">", ">gv", { remap = false })
-- map("v", "<", "<gv", { remap = false })

map("n", "<leader>up", "<cmd>set paste!<cr>", { desc = "Toggle Paste" })

-- diagnostic
local diagnostic_goto = function(next, severity)
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        if next then
            vim.lsp.diagnostic.goto_next({ severity = severity })
        else
            vim.lsp.diagnostic.goto_prev({ severity = severity })
        end
    end
end

map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

map("n", "`n", "<Cmd>bnext<CR>")
map("n", "`<Tab>", "<Cmd>bnext<CR>")
map("n", "<leader><Tab>", "<cmd>bnext<cr>")
map("n", "`p", "<Cmd>bprevious<CR>")
