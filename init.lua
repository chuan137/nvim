-- Most basic config
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.lazyloading = true

local eval = function(v)
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

vim.g.minimal = eval(os.getenv("NVIM_MINIMAL"))

require("deps")
