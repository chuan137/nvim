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

map("n", "<leader>,", "<Cmd>lua Snacks.picker.buffers()<CR>", { desc = "Buffers" })
map("n", "<leader><space>", "<Cmd>lua Snacks.picker.git_files()<CR>", { desc = "Git Files" })
map("n", "<leader>ff", "<Cmd>lua Snacks.picker.git_files()<CR>", { desc = "Git Files" })
map("n", "<leader>fF", "<Cmd>lua Snacks.picker.files()<CR>", { desc = "Files" })
map("n", "<leader>fg", "<Cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Grep Word" })
map("n", "<leader>fo", "<Cmd>lua Snacks.picker.grep_buffers()<CR>", { desc = "Grep Buffers" })
map("n", "<leader>cw", function()
    Snacks.picker.grep_word({ word = vim.fn.expand("<cword>") })
end, { desc = "Grep [C]urrent Word" })

map("n", "<leader>P", "<Cmd>lua Snacks.picker.resume()<CR>", { desc = "Snacks Resume" })
--
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        map("n", "gd", "<Cmd>lua Snacks.picker.lsp_definitions()<CR>", { desc = "Goto Definition" })
        map("n", "gD", "<Cmd>lua Snacks.picker.lsp_declarations()<CR>", { desc = "Goto Declaration" })
        map("n", "gr", "<Cmd>lua Snacks.picker.lsp_references()<CR>", { nowait = true, desc = "References" })
        map("n", "gI", "<Cmd>lua Snacks.picker.lsp_implementations()<CR>", { desc = "Goto Implementation" })
        map("n", "gy", "<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>", { desc = "Goto T[y]pe Definition" })
        map("n", "<leader>ss", "<Cmd>lua Snacks.picker.lsp_symbols()<CR>", { desc = "LSP Symbols" })
        map("n", "<leader>sS", "<Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>", { desc = "LSP Workspace Symbols" })
        map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code Rename" })
    end,
})
-- --     callback = function()
-- --         map("n", "gd", "<Cmd>lua Snacks.picker.lsp_definitions()<CR>", { desc = "Goto Definition" })
-- --         map("n", "gD", "<Cmd>lua Snacks.picker.lsp_declarations()<CR>", { desc = "Goto Declaration" })
-- --         map("n", "gr", "<Cmd>lua Snacks.picker.lsp_references()<CR>", { nowait = true, desc = "References" })
-- --         map("n", "gI", "<Cmd>lua Snacks.picker.lsp_implementations()<CR>", { desc = "Goto Implementation" })
-- --         map("n", "gy", "<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>", { desc = "Goto T[y]pe Definition" })
-- --         map("n", "<leader>ss", "<Cmd>lua Snacks.picker.lsp_symbols()<CR>", { desc = "LSP Symbols" })
-- --         map("n", "<leader>sS", "<Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>", { desc = "LSP Workspace Symbols" })
-- --         map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code Rename" })
-- --
-- --         -- wk.add({ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" })
-- --         -- wk.add({ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" })
-- --         -- wk.add({ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" })
-- --         -- wk.add({ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" })
-- --         -- wk.add({ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" })
-- --         -- wk.add({ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" })
-- --         -- wk.add({ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" })
-- --         -- wk.add({ "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename" })
-- --     end,
-- -- })
-- -
