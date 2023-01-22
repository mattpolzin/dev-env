
--
-- Colorscheme
--
vim.api.nvim_set_option('termguicolors', true)
vim.cmd.colorscheme('onedark')
-- make background slightly darker:
vim.cmd.highlight('Normal       guibg=#16181d')
-- make non-current window status bar more visible:
vim.cmd.highlight('StatusLineNC guibg=#21252c')

--
-- Search Highlight
--
vim.cmd.highlight('link Searchlight DiffDelete')

--
-- FZF
--
vim.keymap.set('n', '<c-p>', function() vim.cmd('Files') end, { silent=true })

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
        ["<c-s>"] = require('telescope.actions').select_horizontal,
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

-- currently using FZF (above) for file finding:
-- vim.cmd [[nnoremap <c-p> :lua require('telescope.builtin').find_files({previewer = false})<CR>]] -- <Cmd>Telescope find_files<CR>]]
vim.cmd.command("Tl :exec 'Telescope live_grep'")
vim.cmd.command("Tg :exec 'Telescope grep_string'")

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

vim.cmd.command("Blame lua require('commands.github').blame()")
vim.cmd.command("-range Show lua require('commands.github').show()")

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
if vim.fn.executable('elm') == 1 then
  require('lsp.elm').setup()
end
if vim.fn.executable('nix') == 1 then
  require('lsp.nix').setup()
end

-- LSP additional external setup:
--
-- npm i -g vscode-langservers-extracted diagnostic-languageserver
--
-- npm i -g typescript typescript-language-server
--
-- https://github.com/elixir-lsp/elixir-ls
--
-- https://github.com/idris-community/idris2-lsp
--
-- npm i -g elm elm-test elm-format @elm-tooling/elm-language-server
--
-- nix profile install nixpkgs#rnix-lsp
-- -OR-
-- cargo install rnix-lsp

--
-- Treesitter
--
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "nix", "lua" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "markdown" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
require('treesitter-context').setup {
  mode = 'topline'
}


--
-- DAP
--
if vim.fn.executable('elixir') == 1 then
  require('dap.elixir').setup()
end

