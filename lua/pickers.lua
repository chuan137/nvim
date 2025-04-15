local map = vim.keymap.set

local get_git_root = function()
    local cwd = vim.fn.expand("%:p:h")
    local root = vim.fn.systemlist("git -C " .. cwd .. " rev-parse --show-toplevel")[1]
    return root
end

map("n", "<leader>E", "<Cmd>lua Snacks.explorer()<CR>", { desc = "Snacks Explorer" })

-- toggle options
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
-- Snacks.toggle.profiler():map("<leader>dpp")
-- Snacks.toggle.profiler_highlights():map("<leader>dph")
Snacks.toggle
    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
    :map("<leader>uc")
Snacks.toggle
    .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
    :map("<leader>uA")

if vim.lsp.inlay_hint then
    Snacks.toggle.inlay_hints():map("<leader>uh")
end

if vim.fn.executable("lazygit") == 1 then
    map("n", "<leader>gg", function()
        Snacks.lazygit({ cwd = get_git_root() })
    end, { desc = "Lazygit (Root Dir)" })
    map("n", "<leader>gG", "<Cmd>lua Snacks.lazygit()<CR>", { desc = "Lazygit (cwd)" })
end

map("n", "<leader>fl", "<Cmd>lua Snacks.picker.git_log_file()<CR>", { desc = "File Logs" })
map("n", "<leader>gl", "<Cmd>lua Snacks.picker.git_log()<CR>", { desc = "Git Log" })
map("n", "<leader>gL", "<Cmd>lua Snacks.picker.git_log_line()<CR>", { desc = "Git Log Line" })
map({ "n", "x" }, "<leader>go", "<Cmd>lua Snacks.gitbrowse()<CR>", { desc = "Git Browse (open)" })
map({ "n", "x" }, "<leader>gY", function()
    Snacks.gitbrowse({
        open = function(url)
            vim.fn.setreg("+", url)
        end,
        notify = false,
    })
end, { desc = "Git Browse (copy)" })

map("n", "<leader><space>", "<Cmd>lua Snacks.picker.git_files()<CR>", { desc = "Pick Git Files" })
map("n", "<leader>,", "<Cmd>lua Snacks.picker.buffers()<CR>", { desc = "Pick Buffers" })
map("n", "<leader>fF", "<Cmd>lua Snacks.picker.files()<CR>", { desc = "Pick Files" })
map("n", "<leader>fg", "<Cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Grep Word" })
map("n", "<leader>fo", "<Cmd>lua Snacks.picker.grep_buffers()<CR>", { desc = "Grep Buffers" })
map("n", "<leader>cw", function()
    Snacks.picker.grep_word({ word = vim.fn.expand("<cword>") })
end, { desc = "Grep [C]urrent Word" })

map("n", "<leader>P", "<Cmd>lua Snacks.picker.resume()<CR>", { desc = "Snacks Resume" })
