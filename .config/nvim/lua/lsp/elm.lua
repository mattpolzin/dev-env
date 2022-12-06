
--
-- Elm LSP
--

local function custom_lsp_attach(client)
  require('lsp.common').setup()
  vim.cmd [[autocmd BufWritePre * lua require('lsp.common').format()]]
end

local M = {}

function M.setup()
  require('lspconfig').elmls.setup({
    on_attach = custom_lsp_attach
  })
end

return M
