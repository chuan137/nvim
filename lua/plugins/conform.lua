return function()
    MiniDeps.add({
        source = "stevearc/conform.nvim",
    })
    require("conform").setup({
        formatters_by_ft = {
            python = { "ruff_fix", "ruff_format" },
            lua = { "stylua" },
            json = { "jq" },
            yaml = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            javascript = { "prettier" },
            typescript = { "prettier" },
        },
    })
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Code Format" })
end
