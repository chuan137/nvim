local add = MiniDeps.add
local M = {}

M.setup = function()
    add({ source = "folke/trouble.nvim" })
    require("trouble").setup()

    local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    map("<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)")
    map("<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)")
    map("<leader>xL", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)")
    map("<leader>xQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)")
    -- { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
    -- { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
end

return M
