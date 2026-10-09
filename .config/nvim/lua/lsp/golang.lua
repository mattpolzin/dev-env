
--
-- Golang LSP
--
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()

  -- evaluate expression
--   vim.keymap.set('n', '<Leader>e', require('helpers.golang').evaluate, { buffer=true })

end

local M = {}

local path_to_golangls = vim.fn.expand("gopls")
local function golang_ls_setup()
  vim.lsp.config("gopls", {
    cmd = { path_to_golangls },
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities
  })
  vim.lsp.enable("gopls")
end

function M.setup()
  golang_ls_setup()
end

return M
