
local M = {}

function M.setup()
  vim.keymap.set('n', '<Leader>b', require'dap'.toggle_breakpoint)
  vim.keymap.set('n', '<F1>', require'dap'.continue)
  vim.keymap.set('n', '<F2>', require'dap'.step_over)
  vim.keymap.set('n', '<F3>', require'dap'.step_into)
  vim.keymap.set('n', '<F4>', require'dap'.repl.open)
  vim.cmd [[command! Debug lua require'dap'.continue()<CR>]]
end

return M
