
--
-- Colorscheme
--
vim.o.termguicolors = true
local onedark = require('onedark')
onedark.setup({  })
onedark.load()
-- make background slightly darker:
vim.cmd.highlight('Normal       guibg=#16181d')
-- make non-current window status bar more visible:
vim.cmd.highlight('StatusLineNC guibg=#21252c')

--
-- FZF
--
vim.keymap.set('n', '<c-p>', function() vim.cmd('Files') end, { silent=true })

-- Workaround for the fact that :GitFiles is just an alias for :GFiles and it
-- collides with :GitSigns in a way that is annoying for tab-completion of commands:
vim.api.nvim_create_augroup('delete_GitFiles_plugin_cmd', {})
vim.api.nvim_create_autocmd("VimEnter", {
  group = 'delete_GitFiles_plugin_cmd',
  callback = function()
    vim.cmd.delcommand("GitFiles")
  end
})

--
-- Misc Helpers
--
vim.keymap.set('n', 'gl', require('commands/open_web_uri').open_under_cursor)

--
-- Telescope
--
require('init.telescope')

--
-- Oil
--
require('oil').setup({
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-h>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-q>"] = "actions.preview",
    ["<C-p>"] = false,
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["g."] = "actions.toggle_hidden",
  },
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
})
-- turn netrw off and use oil.nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd.command('Explore lua require("oil").open()')
vim.cmd.command('Rexplore lua require("oil").open()')
vim.cmd.command('Vexplore :vsplit | lua require("oil").open()<CR>')
vim.cmd.command('Sexplore :split | lua require("oil").open()<CR>')

--
-- Git
--
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})
  end
})

vim.cmd.command("Blame lua require('commands.github').blame()")
vim.cmd.command("-range Show lua require('commands.github').show()")

--
-- Neorg
--
require('init.neorg')

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
if vim.fn.executable('node') == 1 
  and vim.fn.executable('tsserver') == 1
  then
    require('lsp.node').setup()
end
if vim.fn.executable('node') == 1
  and vim.fn.executable('vscode-json-language-server') == 1
  then
    require('lsp.json').setup()
end
if vim.fn.executable('elm') == 1 then
  require('lsp.elm').setup()
end
if vim.fn.executable('nix') == 1 then
  require('lsp.nix').setup()
end
if vim.fn.executable('ghc') == 1
  and vim.fn.executable('haskell-language-server-wrapper') == 1
  then
    require('lsp.haskell').setup()
end
if vim.fn.executable('ruby') == 1
  and vim.fn.executable('solargraph') == 1
  then
    require('lsp.ruby').setup()
end
if vim.fn.executable('swift') == 1 then
    require('lsp.swift').setup()
end
if vim.fn.executable('zig') == 1 then
    require('lsp.zig').setup()
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
-- nix profile install nixpkgs#nixd

--
-- Treesitter
--
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "markdown", "yaml" },

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
-- Treesitter code folding where appropriate:
vim.api.nvim_create_augroup('ruby_ft', {})
vim.api.nvim_create_autocmd("FileType", {
  group = 'ruby_ft',
  pattern = 'ruby',
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
})
vim.api.nvim_create_augroup('elixir_ft', {})
vim.api.nvim_create_autocmd("FileType", {
  group = 'elixir_ft',
  pattern = 'elixir',
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
})
vim.api.nvim_create_augroup('json_ft', {})
vim.api.nvim_create_autocmd("FileType", {
  group = 'json_ft',
  pattern = 'json',
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = 'swift',
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
})


--
-- Tab Completion
--
require('init.tab_completion')

--
-- DAP
--
if vim.fn.executable('elixir') == 1 then
  require('dap.elixir').setup()
end

--
-- Autolist
--
local autolist = require('autolist')
autolist.setup({})
vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
-- vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
-- vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
-- vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
-- vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")
-- vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
-- vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")

require('csvview').setup()

