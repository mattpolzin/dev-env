
--
-- Ruby LSP
--
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()
end

local M = {}

function M.setup()
  vim.lsp.config("solargraph", {
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities,
  })
  vim.lsp.enable("solargraph")
end

return M
