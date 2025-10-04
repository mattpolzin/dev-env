
--
-- Haskell LSP
-- 
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()
end

local M = {}

function M.setup()
  vim.lsp.config("hls", {
    on_attach = custom_lsp_attach,
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
    capabilities = common.capabilities
  })
  vim.lsp.enable("hls")
end

return M
