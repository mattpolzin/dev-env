
--
-- Ruby LSP
--
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()
end

local M = {}

local function solargraph()
  vim.lsp.config("solargraph", {
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities,
  })
  vim.lsp.enable("solargraph")
end

local path_to_ruby_lsp = vim.fn.expand("ruby-lsp")
local function ruby_lsp()
  vim.lsp.config("ruby-lsp", {
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities,
    cmd = {path_to_ruby_lsp, "--use-launcher"},
  })
  vim.lsp.enable("ruby-lsp")
end

function M.setup()
  ruby_lsp()
end

return M
