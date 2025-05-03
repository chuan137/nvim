local map = vim.keymap.set

map("n", "Q", "@q")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("n", "<leader>w", "<C-w>")
map("n", "<leader><Tab>", "<cmd>bnext<cr>")

map("n", "<leader>rp", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>") -- Replace all instance of current word in file
map("v", "<leader>rp", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>") -- Replace all instance of current word in file

-- move current line up/down
map("n", "<M-j>", ":m .+1<CR>==")
map("n", "<M-k>", ":m .-2<CR>==")

-- move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- copy paste
map("n", "<leader>up", "<cmd>set paste!<cr>", { desc = "Toggle Paste" })

-- system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy Line to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste clipboard after selection" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste clipboard before selection" })
-- map("x", "<leader>p", [["_dP]]) -- paste WON'T copy

-- diagnostic
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
