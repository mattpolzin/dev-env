
--
-- Elixir LSP
--
local function custom_lsp_attach(client)
  require('lsp.common').setup()

  -- evaluate expression
  vim.cmd [[nnoremap <Leader>e <Cmd>lua require('helpers.elixir').evaluate()<CR>]]

end

local path_to_elixirls = vim.fn.expand("~/.nix-profile/bin/elixir-ls")

local M = {}

function M.setup()
  require('lspconfig').elixirls.setup({
    cmd = {path_to_elixirls},
--     capabilities = capabilities,
    on_attach = custom_lsp_attach,
    settings = {
      elixirLS = {
	-- Fetch Deps is often get's into a weird state that requires deleting
	-- the .elixir_ls directory and restarting the editor.
	fetchDeps = false
      }
    }
  })
end

return M
