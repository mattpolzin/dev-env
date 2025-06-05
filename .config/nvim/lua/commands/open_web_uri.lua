
local M = {}

function M.open(uri)
  local tmp_file = os.tmpname()

  local suffix = ''
  if string.find(uri, 'github.com') then
    if string.find(uri, '?') then
      suffix = '&raw=true'
    else
      suffix = '?raw=true'
    end
  end

  uri = uri .. suffix

  vim.system({'curl', '-L', '-o', tmp_file, uri}, {text = true}):wait()

  vim.cmd.edit(tmp_file)
  vim.bo.filetype = 'norg'
  os.remove(tmp_file)
end

function M.open_under_cursor()
  M.open(vim.fn.expand('<cfile>'))
end

return M
