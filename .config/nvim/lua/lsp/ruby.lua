
--
-- Ruby LSP
--
local function custom_lsp_attach(client)
  require('lsp.common').setup({ skip_go_to_def = true })
end

-- local path_to_rubyls = vim.fn.expand("bundle exec ruby-lsp")

local M = {}

function M.setup()
  require('lspconfig').ruby_ls.setup({
    cmd = {'bundle', 'exec', 'ruby-lsp'},
--     capabilities = capabilities,
    on_attach = custom_lsp_attach,
    init_options = {
      enabledFeatures = {
        'codeActions',
        'diagnostics',
        'documentHighlights',
        'documentSymbols',
        'formatting',
        'hover',
        'inlayHint',
        'foldingRanges',
        'selectionRanges',
        'semanticHighlighting',
        'onTypeFormatting',
        'codeLens',
      },
    },
  })
end

return M
