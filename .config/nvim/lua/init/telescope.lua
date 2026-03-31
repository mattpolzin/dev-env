
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
        ["<C-s>"] = require('telescope.actions').select_horizontal,
        ["<C-Down>"] = require('telescope.actions').cycle_history_next,
        ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
        ["<C-c>"] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
        ["<C-q>"] = require('telescope.actions.layout').toggle_preview
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

vim.api.nvim_create_user_command("Tr", function() vim.cmd.exec("'Telescope resume'") end, {})

local function telescope_livegrep(cmd)
  require('telescope.builtin').live_grep({
    default_text = (cmd.fargs[1] or '')
  })
end
vim.api.nvim_create_user_command("Tl", telescope_livegrep, { nargs='?' })

local function telescope_grepstring(cmd)
  local search = cmd.fargs[1]
  if search then
    -- make sure we have search= exactly once whether it was passed in or not:
    search = search:gsub('search=','')
    search = 'search=' .. search
  end
  vim.cmd.exec("'Telescope grep_string " .. (search or '') .. "'")
end
vim.api.nvim_create_user_command("Tg", telescope_grepstring, { nargs='?' })

-- Telescope extensions
require('telescope').load_extension('fzf')
