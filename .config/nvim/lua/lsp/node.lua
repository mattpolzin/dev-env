
--
-- Typescript LS & ESLint via Diagnistic LS
--
local common = require('lsp.common')

local function custom_lsp_attach(client)
  common.setup()
end

local M = {}

function M.setup()
  require('lspconfig').tsserver.setup({
    on_attach = custom_lsp_attach,
    capabilities = common.capabilities
  })
  require('lspconfig').diagnosticls.setup(
    {
      filetypes = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'},
      init_options = {
        filetypes = {
          javascript = "eslint",
          typescript = "eslint",
          javascriptreact = "eslint",
          typescriptreact = "eslint"
        },
        linters = {
          eslint = {
            sourceName = "eslint",
            command = "eslint",
            rootPatterns = {
              ".git"
            },
            debounce = 100,
            args = {
              "--stdin",
              "--stdin-filename",
              "%filepath",
              "--format",
              "json"
            },
            parseJson = {
              errorsRoot = "[0].messages",
              line = "line",
              column = "column",
              endLine = "endLine",
              endColumn = "endColumn",
              message = "${message} [${ruleId}]",
              security = "severity"
            },
            securities = {
              [0] = "info", -- actually 'off' for eslint
              [1] = "warning",
              [2] = "error"
            }
          }
        }
      }
  })
end

return M
