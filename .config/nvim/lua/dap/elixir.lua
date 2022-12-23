
local M = {}
local dap = require('dap')

local path_to_elixirls = vim.fn.expand("~/.nix-profile/lib")

function M.setup()
  require('dap.common').setup()

  dap.set_log_level('TRACE')

  dap.adapters.mix_task = {
    type = 'executable',
    command = path_to_elixirls .. '/debugger.sh', -- debugger.bat for windows
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
