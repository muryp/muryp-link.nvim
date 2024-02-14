local DEFAULT_CONFIGS = {
  openCmd = '!xdg-open',
  ---@param TEXT string
  ---@return string
  replaceTexttoLink = function(TEXT)
    -- Remove symbols
    local LINK = TEXT:gsub('[%p%c]', '')
    -- remove emoji
    LINK = LINK:gsub('[\128-\255][\128-\191]*', '')
    -- replace space
    LINK = LINK:gsub('%s+', '-')
    -- Convert to lowercase
    LINK = LINK:lower()
    return '[' .. TEXT .. '](' .. LINK .. ')'
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
    visual = '<CR>',
    unlink = '<leader><CR>',
  },
}

return DEFAULT_CONFIGS
