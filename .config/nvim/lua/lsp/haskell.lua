
--
-- Haskell LSP
-- 
local function custom_lsp_attach(client)
  require('lsp.common').setup()
end

local M = {}

function M.setup()
  require('lspconfig').hls.setup({
    on_attach = custom_lsp_attach,
    filetypes = { 'haskell', 'lhaskell', 'cabal' }
  })
end

return M
