
--
-- LSP Common Setup
--
local M = {}

-- options = {
--   formatting_options = {} -- sent to LSP along with textDocument/format command.
-- }
function M.setup(options)

  local nmap = function(key, fun)
    vim.keymap.set('n', key, fun, { buffer=true })
  end

  nmap('<Leader>t' , vim.lsp.buf.hover)
  nmap('<c-]>'     , vim.lsp.buf.definition)
  nmap('<c-w>]'    , function() vim.cmd('vsplit'); vim.lsp.buf.definition() end)
  nmap('K'         , vim.lsp.buf.code_action)
  nmap('<Leader>d' , vim.lsp.buf.signature_help)
  nmap('<Leader>ia', function() vim.diagnostic.open_float({scope="buffer"}) end)
  nmap('<Leader>in', vim.diagnostic.open_float)
  nmap('[d'        , vim.diagnostic.goto_prev)
  nmap(']d'        , vim.diagnostic.goto_next)

  -- auto-complete via LSP
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- format current buffer
  function M.format()
    if options and options.formatting_options then
      vim.lsp.buf.format { options = options.formatting_options, async = true }
    else
      vim.lsp.buf.format { async = true }
    end
  end
  vim.cmd [[command! Format lua require('lsp.common').format()<CR>]]
end

return M
