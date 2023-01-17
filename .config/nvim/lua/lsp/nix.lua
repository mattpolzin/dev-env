
--
-- Nix LSP
-- 
local function custom_lsp_attach(client)
  require('lsp.common').setup()
end

local M = {}

function M.setup()
  require('lspconfig').rnix.setup({
    on_attach = custom_lsp_attach
  })
end

return M
