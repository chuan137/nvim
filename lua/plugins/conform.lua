local keymap = require("lz.n").keymap({
    "conform.nvim",
    cmd = "ConformInfo",
    before = function()
        MiniDeps.add({
            source = "stevearc/conform.nvim",
        })
    end,
    after = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "ruff" },
                lua = { "stylua" },
                json = { "jq" },
                yaml = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                javascript = { "prettier" },
                typescript = { "prettier" },
            },
        })
    end,
})

keymap.set({ "n", "v" }, "<leader>cf", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Code Format" })
