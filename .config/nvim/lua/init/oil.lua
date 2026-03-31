
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
