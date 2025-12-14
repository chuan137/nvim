-- {
--     'MeanderingProgrammer/render-markdown.nvim',
--     dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
--     -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
--     -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
--     ---@module 'render-markdown'
--     ---@type render.md.UserConfig
--     opts = {},
-- }

return function()
    MiniDeps.add({
        source = "MeanderingProgrammer/render-markdown.nvim",
        depends = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
    })

    require("render-markdown").setup({
        code = {
            sign = false,
            width = "block",
            right_pad = 1,
        },
        heading = {
            sign = false,
            icons = {},
        },
        checkbox = {
            enabled = false,
        },
    })

    -- if Snacks is installed, add markdown rendering to Snacks preview
    -- Snacks.toggle({
    --     name = "Render Markdown",
    --     get = require("render-markdown").get,
    --     set = require("render-markdown").set,
    -- }):map("<leader>um")
end
