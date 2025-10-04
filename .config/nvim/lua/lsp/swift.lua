
--
-- Swift LSP
--
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()
end

local M = {}

function M.setup()
  vim.lsp.config("sourcekit", {
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities
  })
  vim.lsp.enable("sourcekit")
end

return M
