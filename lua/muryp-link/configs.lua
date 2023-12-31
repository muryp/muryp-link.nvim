local DEFAULT_CONFIGS = {
  openCmd = '!xdg-open',
  ---@param TEXT string
  ---@return string
  replaceTexttoLink = function(TEXT)
    return '[' .. TEXT .. '](' .. TEXT .. ')'
  end,
  ---if you use `/slug` maybe you cannot open the file. with this you can direct slug into the file
  ---@param FILE string link non url (like file/slug/not contains http(s))
  ---@return string
  replaceFileLink = function(FILE)
    if FILE:match '^.+(%..+)$' then
      return FILE
    end
    return FILE .. '.md'
  end,
  ---@return boolean
  on_attach = function()
    return true
  end,
  maps = {
    enter = '<CR>',
    unlink = '<leader><CR>',
  },
}

return DEFAULT_CONFIGS
