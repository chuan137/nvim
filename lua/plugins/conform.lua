return function()
    MiniDeps.add({
        source = "stevearc/conform.nvim",
    })
    require("conform").setup({
        formatters_by_ft = {
            python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
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

    -- Create LspFormat command to format using LSP via conform
    vim.api.nvim_create_user_command("LspFormat", function(opts)
        local range = nil
        if opts.range > 0 then
            range = {
                start = { opts.line1, 0 },
                ["end"] = { opts.line2, 999999 },
            }
        end

        require("conform").format({
            async = true,
            lsp_format = "prefer",
            range = range,
        })
    end, {
        range = true,
        desc = "Format code using LSP (supports visual selection)",
    })

    vim.keymap.set("n", "<leader>cc", "v%:LspFormat<CR>", { desc = "Code Format Current Block" })
end
