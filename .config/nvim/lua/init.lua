
--
-- Colorscheme
--
vim.cmd [[ set termguicolors ]]
vim.cmd [[ colorscheme onedark    ]]
-- make background slightly darker:
vim.cmd [[ hi Normal       guibg=#16181d ]]
-- make non-current window status bar more visible:
vim.cmd [[ hi StatusLineNC guibg=#21252c ]]

--
-- Search Highlight
--
vim.cmd [[ highlight link Searchlight DiffDelete ]]

--
-- Telescope
--

local ignore_patterns = {
  -- dependency and build folders
  ".*node_modules/.*",
  ".*build/.*",
  ".*bundle/.*",
  ".*.bundle/.*",
  ".*tmp/.*",
  ".*icons/.*",
  -- images
  ".*.png",
  -- other non-editables
  ".*.zip",
  ".*.tar.gz",
  ".*.tgz",
  -- tags
  ".*/?tags$",
  -- hidden files and folders
  ".*.git/.*",
  ".*.elixir_ls/.*",
  -- editor session
  ".*~$",
}

require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    file_ignore_patterns = ignore_patterns,
    mappings = {
      i = {
        ["<c-Down>"] = require('telescope.actions').cycle_history_next,
        ["<c-Up>"] = require('telescope.actions').cycle_history_prev
      }
    }
  }
})

vim.cmd [[nnoremap <c-p> <Cmd>Telescope find_files<CR>]]
require('telescope').load_extension('fzf')

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

vim.cmd [[command Blame lua require('commands.github').blame()]]
vim.cmd [[command -range Show lua require('commands.github').show()]]

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

