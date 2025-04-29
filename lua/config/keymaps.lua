local map = vim.keymap.set

-- Space as the leader
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Apply recordings conveniently
map("n", "Q", "@q")

-- Default overrides
map("n", "<ESC>", "<CMD>nohlsearch<CR>")
map("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- Copy and paste
map({ "n", "x" }, "<leader>a", "gg<S-v>G", { desc = "Select [A]ll" })
map("x", "<leader>y", '"+y', { desc = "[Y]ank to the system clipboard (+)" })
map(
    "x",
    "<leader>p",
    '"_dP', --> [d]elete the selection and send content to _ void reg then [P]aste (b4 cursor unlike small p)
    { desc = "[P]aste the current selection without overriding the register" }
)

map(
    "n",
    "<leader>k",
    ":echo 'Choose a buf to delete (blank to choose curr)'<CR>" .. ":ls<CR>" .. ":bdelete<SPACE>",
    { silent = true, desc = "[K]ill a buffer" }
)

-- Custom keymaps
map("i", "jk", "<ESC>", { desc = "Better ESC" })
map("i", "<C-s>", "<C-g>u<ESC>[s1z=`]a<C-g>u", { desc = "Fix nearest [S]pelling error and put the cursor back" })

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
            vim.diagnostic.goto_next({ severity = severity })
        else
            vim.diagnostic.goto_prev({ severity = severity })
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

local noremap_silent = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>l", function()
    local win = vim.api.nvim_get_current_win()
    local qf_winid = vim.fn.getloclist(win, { winid = 0 }).winid
    local action = qf_winid > 0 and "lclose" or "lopen"
    vim.cmd(action)
end, noremap_silent)

vim.keymap.set("n", "<leader>q", function()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    local action = qf_winid > 0 and "cclose" or "copen"
    vim.cmd("botright " .. action)
end, noremap_silent)
