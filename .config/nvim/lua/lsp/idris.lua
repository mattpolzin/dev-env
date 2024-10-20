
--
-- Idris LSP
-- 
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()

  local nmap = function(key, fun)
    vim.keymap.set('n', key, fun, { buffer=true })
  end

  -- evaluate expression
  nmap('<Leader>e', require('idris2.repl').evaluate)

  -- open window
  nmap('<Leader>i', require('idris2.hover').open_split)

  -- case split
  nmap('<Leader>c', require('idris2.code_action').case_split)

  -- make case
  nmap('<Leader>mc', require('idris2.code_action').make_case)

  -- with block
  nmap('<Leader>w', require('idris2.code_action').make_with)

  -- make lemma
  nmap('<Leader>l', require('idris2.code_action').make_lemma)

  -- add clause
  nmap('<Leader>a', require('idris2.code_action').add_clause)

  -- expression search
  nmap('<Leader>s', require('idris2.code_action').expr_search)

  -- generate def
  nmap('<Leader>g', require('idris2.code_action').generate_def)

  -- refine hole
  nmap('<Leader>f', require('idris2.code_action').refine_hole)

  -- list metavars (holes)
  nmap('<Leader>h', require('idris2.metavars').request_all)

  -- browse a module
  vim.cmd [[command! Browse lua require('idris2.browse').browse()<CR>]]
end

local function save_hook(action)
  if not action or not action.title then
    return
  end

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
    code_action_post_hook = save_hook,
    capabilities = common.capabilities
  })
end

return M
