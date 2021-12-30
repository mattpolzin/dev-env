
--
-- Telescope
--

require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    file_ignore_patterns = {
      ".*node_modules/.*",
      ".*build/.",
      ".*bundle/.*",
      ".*/icons/.*",
      ".*/tags$"
    }
  }
})

vim.cmd [[nnoremap <c-p> <Cmd>Telescope find_files<CR>]]
require('telescope').load_extension('fzf')

--
-- LSP
-- 
vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(
    vim.lsp.handlers.hover,
    {
      border = "single"
    }
)

require('lsp.elixir').setup()
require('lsp.idris').setup()

