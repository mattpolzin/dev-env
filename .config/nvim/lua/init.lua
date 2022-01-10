
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

--
-- Git
--
require('gitsigns').setup({
  keymaps = {
    -- Default keymap options
    noremap = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'"}
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
require('lsp.node').setup()
require('lsp.json').setup()

-- LSP additional external setup:
--
-- npm i -g vscode-langservers-extracted
--
-- npm i -g typescript typescript-language-server
--
-- https://github.com/elixir-lsp/elixir-ls
--
-- https://github.com/idris-community/idris2-lsp

