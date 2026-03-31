
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
require('init.oil')

--
-- Git
--
require('init.git')

--
-- Neorg
--
require('init.neorg')

--
-- LSP
-- 
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
require('init.treesitter')

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

