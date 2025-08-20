local M = {}

M.eval = function(v)
    if v == nil then
        return nil
    end
    if v == "true" or v == "1" then
        return true
    end
    if v == "false" or v == "0" then
        return false
    end
    return nil
end

M.register_keys = function(keys)
    -- example:
    -- { "<leader>go", function () Snacks.gitbrowse() end, desc = "Git Browse (open)" },

    for _, key in ipairs(keys) do
        -- if type(key) ~= "table" or #key < 2 then
        --     error("Invalid keymap format. Expected a table with at least two elements.")
        -- end

        local mode, lhs, rhs = key.mode or "n", key[1], key[2]
        local opts = {}
        opts.desc = key.desc or ""
        opts.silent = key.silent ~= false
        opts.noremap = key.noremap ~= false

        if type(rhs) == "function" then
            vim.keymap.set(mode, lhs, rhs, opts)
        else
            vim.keymap.set(mode, lhs, "<Cmd>" .. rhs .. "<CR>", opts)
        end
    end
end

return M
