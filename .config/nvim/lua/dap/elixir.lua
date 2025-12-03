
local M = {}
local dap = require('dap')

local path_to_elixirls = vim.fn.exepath("elixir-ls")
local split_path = vim.fn.split(path_to_elixirls, '/')
-- remove last element ('elixir-ls')
table.remove(split_path)
local path = '/' .. table.concat(split_path, '/')
local path_to_debugger_script = vim.fn.expand(path .. '/elixir-debug-adapter')
if vim.fn.executable(path_to_debugger_script) == 0 then
  -- remove one more path element ('bin')
  table.remove(split_path)
  path = '/' .. table.concat(split_path, '/')
  path_to_debugger_script = vim.fn.expand(path .. '/lib/debug_adapter.sh')
end

function M.setup()
  require('dap.common').setup()

  dap.set_log_level('TRACE')

  dap.adapters.mix_task = {
    type = 'executable',
    command = path_to_debugger_script,
    args = {}
  }

  dap.configurations.elixir = {
    {
      type = "mix_task",
      name = "mix test",
      task = 'test',
      taskArgs = {"--trace"},
      request = "launch",
      startApps = true, -- for Phoenix projects
      projectDir = vim.fn.getcwd(),
      requireFiles = {
        "test/**/test_helper.exs",
        "test/**/*_test.exs"
      }
    },
    {
      type = "mix_task",
      name = "phx.server",
      request = "launch",
      task = "phx.server",
      projectDir = vim.fn.getcwd()
    },
    {
      type = "mix_task",
      name = "escript",
      request = "launch",
      task = "run_escript",
      projectDir = vim.fn.getcwd()
    }
  }
end

return M
