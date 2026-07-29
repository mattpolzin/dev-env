
--
-- Elixir LSP
--
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()

  -- evaluate expression
  vim.keymap.set('n', '<Leader>e', require('helpers.elixir').evaluate, { buffer=true })

end

local M = {}

local path_to_elixirls = vim.fn.expand("elixir-ls")
local function elixir_ls_setup()
  vim.lsp.config("elixirls", {
    cmd = { path_to_elixirls },
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities,
    settings = {
      elixirLS = {
        -- Fetch Deps is often get's into a weird state that requires deleting
        -- the .elixir_ls directory and restarting the editor.
        fetchDeps = false
      }
    }
  })
  vim.lsp.enable("elixirls")
end

local path_to_expert = vim.fn.expand("expert")
local function expert_lsp_setup()
  vim.lsp.config("expert", {
    cmd = { path_to_expert, '--stdio' },
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities,
  })
  vim.lsp.enable("expert")
end

function M.setup()
--   expert_lsp_setup()
  elixir_ls_setup()
end

return M
