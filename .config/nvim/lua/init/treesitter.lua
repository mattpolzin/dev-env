
require('treesitter-context').setup {
  mode = 'topline'
}

local function use_treesitter_folding()
  vim.wo[0][0].foldmethod = 'expr'
  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
end

local function use_treesitter_highlighting()
  vim.treesitter.start()
end

local function treesitter_ft_autogroup(filetype, highlight, fold)
  vim.api.nvim_create_augroup(filetype .. '_ft', {})
  vim.api.nvim_create_autocmd("FileType", {
    group = filetype .. '_ft',
    pattern = filetype,
    callback = function()
      if highlight then
        use_treesitter_highlighting()
      end
      if fold then
        use_treesitter_folding()
      end
    end
  })
end

-- Treesitter highlighting and code folding where appropriate:
-- At times in past these were broken: "markdown", "yaml"
local filetypes = {
  authzed = { highlight = true, fold = true },
  bash = { highlight = true, fold = true },
  c = { highlight = true, fold = true },
  cpp = { highlight = true, fold = true },
  css = { highlight = true, fold = true },
  csv = { highlight = true, fold = true },
  dhall = { highlight = true, fold = true },
  diff = { highlight = true, fold = true },
  dockerfile = { highlight = true, fold = true },
  dot = { highlight = true, fold = true },
  eex = { highlight = true, fold = true },
  elixir = { highlight = true, fold = true },
  elm = { highlight = true, fold = true },
  embedded_template = { highlight = true, fold = true },
  git_rebase = { highlight = true, fold = true },
  gitcommit = { highlight = true, fold = true },
  gitignore = { highlight = true, fold = true },
  glimmer = { highlight = true, fold = true },
  haskell = { highlight = true, fold = true },
  html = { highlight = true, fold = true },
  ini = { highlight = true, fold = true },
  javascript = { highlight = true, fold = true },
  json = { highlight = true, fold = true },
  lua = { highlight = true, fold = true },
  make = { highlight = true, fold = true },
  markdown = { highlight = true, fold = true },
  mermaid = { highlight = true, fold = true },
  nix = { highlight = true, fold = true },
  norg = { highlight = true, fold = true },
  norg_meta = { highlight = true, fold = true },
  python = { highlight = true, fold = true },
  query = { highlight = true, fold = true },
  ruby = { highlight = true, fold = true },
  scheme = { highlight = true, fold = true },
  scss = { highlight = true, fold = true },
  sql = { highlight = true, fold = true },
  swift = { highlight = true, fold = true },
  tsx = { highlight = true, fold = true },
  typescript = { highlight = true, fold = true },
  vim = { highlight = true, fold = true },
  vimdoc = { highlight = true, fold = true },
  yaml = { highlight = true, fold = true }
}
for ft, cfg in pairs(filetypes) do
  treesitter_ft_autogroup(ft, cfg.highlight, cfg.fold)
end

