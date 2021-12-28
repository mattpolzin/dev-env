
--
-- Telescope
--

require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    file_ignore_patterns = {
      ".*node_modules/.*",
      ".*build/.",
      ".*bundle/.*"
    }
  }
})

vim.cmd [[nnoremap <c-p> <Cmd>Telescope find_files<CR>]]
require('telescope').load_extension('fzf')

--
-- Idris LSP
-- 
local custom_lsp_attach = function(client)
  vim.cmd [[nnoremap <Leader>t <Cmd>lua vim.lsp.buf.hover()<CR>]]
  vim.cmd [[nnoremap <Leader>in <Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]]
  vim.cmd [[nnoremap <c-]> <Cmd>lua vim.lsp.buf.definition()<CR>]]
  vim.cmd [[nnoremap K <Cmd>lua vim.lsp.buf.code_action()<CR>]]
  vim.cmd [[nnoremap <Leader>d <Cmd>lua vim.lsp.buf.signature_help()<CR>]]

  -- auto-complete via LSP
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- evaluate expression
  vim.cmd [[nnoremap <Leader>e <Cmd>lua require('idris2.repl').evaluate()<CR>]]

  -- open window
  vim.cmd [[nnoremap <Leader>i <Cmd>lua require('idris2.hover').open_split()<CR>]]

  -- case split
  vim.cmd [[nnoremap <Leader>c <Cmd>lua require('idris2.code_action').case_split()<CR>]]

  -- make case
  vim.cmd [[nnoremap <Leader>mc <Cmd>lua require('idris2.code_action').make_case()<CR>]]

  -- with block
  vim.cmd [[nnoremap <Leader>w <Cmd>lua require('idris2.code_action').make_with()<CR>]]

  -- make lemma
  vim.cmd [[nnoremap <Leader>l <Cmd>lua require('idris2.code_action').make_lemma()<CR>]]

  -- add clause
  vim.cmd [[nnoremap <Leader>a <Cmd>lua require('idris2.code_action').add_clause()<CR>]]

  -- expression search
  vim.cmd [[nnoremap <Leader>s <Cmd>lua require('idris2.code_action').expr_search()<CR>]]

  -- generate def
  vim.cmd [[nnoremap <Leader>g <Cmd>lua require('idris2.code_action').generate_def()<CR>]]

  -- refine hole
  vim.cmd [[nnoremap <Leader>f <Cmd>lua require('idris2.code_action').refine_hole()<CR>]]

  -- list metavars (holes)
  vim.cmd [[nnoremap <Leader>h <Cmd>lua require('idris2.metavars').request_all()<CR>]]

  -- browse a module
  vim.cmd [[command Browse lua require('idris2.browse').browse()<CR>]]
end

local introspect = require('idris2.code_action').introspect_filter
local filters = require('idris2.code_action').filters

local save_hook = function(action)
  if introspect(action) == filters.MAKE_CASE
    or introspect(action) == filters.MAKE_WITH then
      return
  end
  vim.cmd('sleep 10m')
  vim.cmd('silent write')
end

require('idris2').setup({
  server = {on_attach = custom_lsp_attach},
  code_action_post_hook = save_hook
})

