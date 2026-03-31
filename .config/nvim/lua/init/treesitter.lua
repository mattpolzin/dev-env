
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
local filetypes = {
  ruby = { highlight = true, fold = true },
  elixir = { highlight = true, fold = true },
  json = { highlight = true, fold = true },
  swift = { highlight = true, fold = true }
}
for ft, cfg in pairs(filetypes) do
  treesitter_ft_autogroup(ft, cfg.highlight, cfg.fold)
end

