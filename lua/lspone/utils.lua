local M = {}

M.is_big_file = function(bufnr)
  local size = vim.fn.getfsize(vim.fn.bufname(bufnr))
  return size > 1000000
end

return M
