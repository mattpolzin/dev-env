
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
require("neorg").setup {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.completion"] = { 
      config = {
        engine = "nvim-cmp",
        name = "[Norg]" 
      } 
    },
    ["core.concealer"] = { -- Adds pretty icons to your documents
      config = {
        icon_preset = 'diamond',
        icons = {
          todo = {
            done = {
              icon = "✓",
            },
            pending = {
              icon = "◌",
            },
            undone = {
              icon = " ",
            },
          },
        },
      }
    },
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          notes = "~/notes",
        },
        default_workspace = "notes",
      },
    },
    ["core.summary"] = {},
    ["core.export"] = {},
    ["core.esupports.metagen"] = {
      config = {
        type = "auto",
        template = {
          -- The title field generates a title for the file based on the filename.
          { "title", },

          -- The description field is always kept empty for the user to fill in.
          { "description", },

          -- The authors field is autopopulated by querying the current user's system username.
          { "authors", },

          -- The categories field is always kept empty for the user to fill in.
          { "categories", "[]" },

          -- The created field is populated with the current date as returned by `os.date`.
          { "created", },

          -- When creating fresh, new metadata, the updated field is populated the same way
          -- as the `created` date.
          { "updated", },

          -- The version field determines which Norg version was used when
          -- the file was created.
          { "version", },
        },
      },
    },
  },
}
vim.cmd.command("Todo :edit ~/notes/Todos.norg")
vim.cmd.command("Index :Neorg index")
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.norg"},
  command = "set conceallevel=3"
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
if vim.fn.executable('ghc') == 1
  and vim.fn.executable('haskell-language-server-wrapper') == 1
  then
    require('lsp.haskell').setup()
end
if vim.fn.executable('ruby') == 1 then
    require('lsp.ruby').setup()
end
if vim.fn.executable('swift') == 1 then
    require('lsp.swift').setup()
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
  pattern = "ruby",
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
  end
})
vim.api.nvim_create_augroup('json_ft', {})
vim.api.nvim_create_autocmd("FileType", {
  group = 'json_ft',
  pattern = "json",
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "swift",
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
  end
})


--
-- Tab Completion
--
local cmp = require'cmp'
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
--   window = {
--     -- completion = cmp.config.window.bordered(),
--     -- documentation = cmp.config.window.bordered(),
--   },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

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
vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
-- vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")
-- vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
-- vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")

