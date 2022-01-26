
local M = {}

local function get_cursor_line()
  return vim.api.nvim_win_get_cursor(0)[1]
end

local function get_fname()
  return vim.api.nvim_buf_get_name(0):gsub(vim.loop.cwd(), '')
--   return vim.fn.expand('%')
end

local function repo()
  local remote = vim.fn.system('git config --get remote.origin.url'):gsub('\n', '')
  if remote:find('git@github.com') then
    return remote:gsub('git@github.com:','https://github.com/'):gsub('%.git','')
  else
    return remote:gsub('%.git','')
  end
end

local function uri_prefix(fn)
  return repo() .. '/' .. fn .. '/master/'
end

local function open(description, uri)
  vim.notify(vim.inspect(description .. ' at ' .. uri))
  vim.cmd('silent !open \'' .. uri:gsub('#','\\#') .. '\'')
end

function M.blame()
  local line = get_cursor_line()
  local uri = uri_prefix('blame') .. get_fname() .. '#L' .. line

  open('Git Blame', uri)
end

function M.show()
  local line1 = vim.api.nvim_buf_get_mark(0, "<")[1]
  local line2 = vim.api.nvim_buf_get_mark(0, ">")[1]
  if line1 == 0 and line2 == 0 then
    line1 = get_cursor_line()
    line2 = line1
  end
  local uri = uri_prefix('blob') .. get_fname() .. '#L' .. line1 .. '..L' .. line2

  open('Show', uri)
end

return M
