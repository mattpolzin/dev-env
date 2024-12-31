
--
-- Zig LSP
--
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()
end

local M = {}

function M.setup()
  require('lspconfig').zig.setup({
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities
  })
end

return M
