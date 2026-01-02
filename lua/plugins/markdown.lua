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
    -- Create autocommand to lazy load markdown plugin only for markdown filetypes
    local markdown_loaded = false
    
    local function load_markdown_plugin()
        if markdown_loaded then
            return
        end
        markdown_loaded = true

        -- =====================================================================
        -- Configure render-markdown.nvim
        -- =====================================================================
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
        Snacks.toggle({
            name = "Render Markdown",
            get = require("render-markdown").get,
            set = require("render-markdown").set,
        }):map("<leader>um")
        
        -- =====================================================================
        -- Configure markdown-preview.nvim
        -- =====================================================================
        -- vim.g.mkdp_filetypes = { "markdown" }

        -- MiniDeps.add({
        --     source = "iamcco/markdown-preview.nvim",
        --     hooks = {
        --         post_checkout = function(path, _, _)
        --             vim.fn.system({ "npm", "install" }, path .. "/app")
        --         end,
        --     },
        -- })
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
