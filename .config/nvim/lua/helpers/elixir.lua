
local Input = require('nui.input')

local M = {}

local term_popup_options = {
  relative = "cursor",
  position = {
    row = 1,
    col = 0,
  },
  size = 75,
  border = {
    style = "rounded",
    highlight = "FloatBorder",
    text = {
      top = "Evaluate",
      top_align = "left",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal",
  },
}

function M.evaluate()
  local expr = vim.api.nvim_eval('input("Expression: ")')
  local command = table.concat {"silent! r ! mix run -e \"IO.inspect(", expr, ")\""}
  require('helpers.misc').scratch(command)
end

function M.evaluate_float()
  local input = Input(term_popup_options, {
    prompt = '> ',
    default_value = '',
    on_submit = function(value)
      local command = table.concat {"r ! mix run -e \"IO.inspect(", value, ")\""}
      require('helpers.misc').scratch(command)
    end,
  })
  input:mount()
end

return M
