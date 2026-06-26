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
    -- The plugin loader reads this global before our explicit setup may run.
    -- Need this to disable the markdown preview by default.
    vim.g.render_markdown_config = { enabled = false }

    -- Create autocommand to lazy load markdown configs only for markdown filetypes
    local markdown_loaded = false

    local function load_markdown_plugin()
        if markdown_loaded then
            return
        end
        markdown_loaded = true

        -- notify
        vim.notify("Loading markdown plugin...", vim.log.levels.INFO, { title = "Markdown" })

        MiniDeps.add({
            source = "selimacerbas/markdown-preview.nvim",
            depends = { "selimacerbas/live-server.nvim" },
        })

        MiniDeps.add({
            source = "MeanderingProgrammer/render-markdown.nvim",
            depends = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
        })

        require("render-markdown").setup({
            enabled = false,
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = true,
                icons = {},
            },
            checkbox = {
                enabled = true,
            },
        })

        -- if Snacks is installed, add markdown rendering to Snacks preview
        if pcall(require, "snacks") then
            Snacks.toggle({
                name = "Render Markdown",
                get = require("render-markdown").get,
                set = require("render-markdown").set,
            }):map("<leader>um")
        end

        require("markdown_preview").setup({
            -- all optional; sane defaults shown
            port = 8421,
            open_browser = true,
            debounce_ms = 300,
        })
    end

    -- Set up autocommand for markdown filetype
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            load_markdown_plugin()
        end,
        desc = "Load markdown plugin for markdown files",
    })
end
