
--
-- Idris LSP
-- 
local function custom_lsp_attach(client)
  require('lsp.common').setup()

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
  vim.cmd [[command! Browse lua require('idris2.browse').browse()<CR>]]
end

local function save_hook(action)
  local introspect = require('idris2.code_action').introspect_filter
  local filters = require('idris2.code_action').filters

  if introspect(action) == filters.MAKE_CASE
    or introspect(action) == filters.MAKE_WITH then
      return
  end
  vim.cmd('sleep 10m')
  vim.cmd('silent write')
end

local M = {}

function M.setup()
  require('idris2').setup({
    server = {on_attach = custom_lsp_attach},
    code_action_post_hook = save_hook
  })
end

return M
