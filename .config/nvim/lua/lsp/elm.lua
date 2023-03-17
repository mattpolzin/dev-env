
--
-- Elm LSP
--

local function format_and_save()
  vim.lsp.buf.format { async = false }
  vim.cmd('write')
end

local function custom_lsp_attach(client)
  require('lsp.common').setup()
--   vim.cmd('autocmd BufWritePre * lua require('lsp.common').format()')
  vim.keymap.set('n', '<Leader>f', format_and_save, { buffer=true })
end

local M = {}

function M.setup()
  require('lspconfig').elmls.setup({
    on_attach = custom_lsp_attach
  })
end

return M
