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

return M
