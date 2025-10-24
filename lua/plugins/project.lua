local M = {}

M.setup = function()
    MiniDeps.add({ source = "ahmedkhalf/project.nvim" })
    require("project_nvim").setup({})

    -- debug print current project path
    vim.keymap.set("n", "<leader>fx", function()
        -- get current project path from project_nvim.history
        local projects = require("project_nvim.utils.history").get_recent_projects()
        -- get last project
        local last_project = projects[#projects]
        for _, project in ipairs(projects) do
            print("Project Path: " .. project)
        end

        -- print("Current Project Path: " .. history.read_projects_from_history())
    end, { desc = "Project debug" })
end

M.get_current_project_path = function()
    local projects = require("project_nvim.utils.history").get_recent_projects()
    if #projects == 0 then
        return nil
    else
        return projects[#projects]
    end
end

return M
