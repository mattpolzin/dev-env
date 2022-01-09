
--
-- LSP Common Setup
--
local M = {}

-- options = {
--   formatting_options = {} -- sent to LSP along with textDocument/format command.
-- }
function M.setup(options)

  vim.cmd [[nnoremap <Leader>t <Cmd>lua vim.lsp.buf.hover()<CR>]]
  vim.cmd [[nnoremap <Leader>in <Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]]
  vim.cmd [[nnoremap <c-]> <Cmd>lua vim.lsp.buf.definition()<CR>]]
  vim.cmd [[nnoremap <c-w>] :vsplit <bar> lua vim.lsp.buf.definition()<CR>]]
  vim.cmd [[nnoremap K <Cmd>lua vim.lsp.buf.code_action()<CR>]]
  vim.cmd [[nnoremap <Leader>d <Cmd>lua vim.lsp.buf.signature_help()<CR>]]
  vim.cmd [[nnoremap [d <cmd>lua vim.diagnostic.goto_prev()<CR>]]
  vim.cmd [[nnoremap ]d <cmd>lua vim.diagnostic.goto_next()<CR>]]

  -- auto-complete via LSP
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- format current buffer
  function M.format()
    if options and options.formatting_options then
      vim.lsp.buf.formatting({options = options.formatting_options})
    else
      vim.lsp.buf.formatting()
    end
  end
  vim.cmd [[command! Format lua require('lsp.common').format()<CR>]]
end

return M
