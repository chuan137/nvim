local M = {}

M.setup = function()
    MiniDeps.add({
        source = "CopilotC-Nvim/CopilotChat.nvim",
        depends = {
            { source = "zbirenbaum/copilot.lua" },
            { source = "nvim-lua/plenary.nvim", checkout = "master" },
        },
        hooks = {
            post_checkout = function()
                -- "make tiktoken",
                local cmd = { "make", "tiktoken" }
                local cwd = vim.fn.stdpath("data") .. "/site/pack/deps/opt/CopilotChat.nvim"
                vim.notify("make tiktoken in " .. cwd, vim.log.levels.INFO)
                vim.system(cmd, { cwd = cwd }, function(o)
                    if o.code > 0 then
                        vim.notify("CopilotChat.nvim: failed to build: " .. o.stderr, vim.log.levels.ERROR)
                    end
                end)
            end,
        },
    })

    require("CopilotChat").setup()
end

return M
