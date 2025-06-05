
local M = {}

function M.open(uri)

  local fname_extension = vim.fn.fnamemodify(uri, ':e')

  local tmp_file = os.tmpname()
  if fname_extension ~= '' then
    tmp_file = tmp_file .. '.' .. fname_extension
  end

  local uri_suffix = ''
  if string.find(uri, 'github.com') then
    if string.find(uri, '?') then
      uri_suffix = '&raw=true'
    else
      uri_suffix = '?raw=true'
    end
  end

  uri = uri .. uri_suffix

  vim.system({'curl', '-L', '-o', tmp_file, uri}, {text = true}):wait()

  vim.cmd.edit(tmp_file)
  os.remove(tmp_file)
end

function M.open_under_cursor()
  M.open(vim.fn.expand('<cfile>'))
end

return M
