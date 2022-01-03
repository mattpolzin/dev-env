
local M = {}

function M.scratch(command)
  vim.cmd [[
    execute '10split '
    execute 'enew'
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
  ]]
  vim.cmd(command)
end

return M
