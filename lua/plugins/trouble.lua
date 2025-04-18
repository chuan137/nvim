local specs = {
    "trouble.nvim",
    cmd = "Trouble",
    before = function()
        MiniDeps.add({
            source = "folke/trouble.nvim",
        })
    end,
    after = function()
        require("trouble").setup()
    end,
}

local keymap = require("lz.n").keymap(specs)

local keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    -- { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
    -- { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
}

for _, v in ipairs(keys) do
    local lhs = v[1]
    local rhs = v[2]
    local desc = v["desc"]
    keymap.set("n", lhs, rhs, { desc = desc })
end

return specs

