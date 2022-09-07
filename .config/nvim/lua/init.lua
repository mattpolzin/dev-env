
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
  ".*.bundle/.*",
  ".*build/.*",
  ".*bundle/.*",
  ".*icons/.*",
  ".*node_modules/.*",
  ".*tmp/.*",
  ".*vendor/.*",
  -- images
  ".*.png$",
  -- other non-editables
  ".*.zip$",
  ".*.tar.gz$",
  ".*.tgz$",
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
        ["<c-Up>"] = require('telescope.actions').cycle_history_prev,
        ["<c-p>"] = require('telescope.actions.layout').toggle_preview
      }
    }
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
    },
  }
})

vim.cmd [[nnoremap <c-p> :lua require('telescope.builtin').find_files({previewer = false})<CR>]] -- <Cmd>Telescope find_files<CR>]]
vim.cmd [[command Tl :exec 'Telescope live_grep']]
vim.cmd [[command Tg :exec 'Telescope grep_string']]

-- Telescope extensions
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
-- Mind
--
require('mind').setup({
  ui = {
    root_marker   = "↪ ",
    url_marker    = "🌎 ",
    select_marker = "⦿ ",
    icon_preset = {
      { "↪ ", "Sub-project" },
      { "📰 ", "Journal, newspaper, weekly and daily news" },
      { "💡 ", "For when you have an idea" },
      { " ", "Note taking?" },
      { "陼", "Task management" },
      { "⏹  ", "Uncheck, empty square or backlog" },
      { " ", "Full square or on-going" },
      { "✅ ", "Check or done" },
      { "🗑️ ", "Trash bin, deleted, cancelled, etc." },
      { "🐙 ", "GitHub" },
      { " ", "Monitoring" },
      { " ", "Internet, Earth, everyone!" },
      { "⏸️ ", "Frozen, on-hold" },
    }
  }
})

--
-- Autolist
--
require('autolist').setup({
  invert = {
    toggles_checkbox = true,
    ul_marker = "*",
    ol_incrementable = "1",
    ol_delim = ".",
  }
})

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
if vim.fn.executable('elixir') == 1 then
  require('lsp.elixir').setup()
end
if vim.fn.executable('idris2') == 1 then
  require('lsp.idris').setup()
end
if vim.fn.executable('node') == 1 then
  require('lsp.node').setup()
end
if vim.fn.executable('node') == 1 then
  require('lsp.json').setup()
end

-- LSP additional external setup:
--
-- npm i -g vscode-langservers-extracted
--
-- npm i -g typescript typescript-language-server
--
-- https://github.com/elixir-lsp/elixir-ls
--
-- https://github.com/idris-community/idris2-lsp

