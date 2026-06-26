return function()
    local ns = vim.api.nvim_create_namespace("bullet_icon")

    local function decorate_bullets()
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
        for i = 0, vim.api.nvim_buf_line_count(0) - 1 do
            local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
            if line and line:match("^%s*[-*+]%s") then
                local bullet_start = line:find("[-*+]")
                if bullet_start then
                    vim.api.nvim_buf_set_extmark(0, ns, i, bullet_start - 1, {
                        virt_text = { { "•", "Special" } }, -- Change "•" to your desired icon
                        virt_text_pos = "overlay",
                        hl_mode = "combine",
                    })
                end
            end
        end
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "TextChanged", "TextChangedI" }, {
        pattern = "*.md",
        callback = decorate_bullets,
    })
end
