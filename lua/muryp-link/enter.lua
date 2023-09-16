local CheckLink  = require('nvim-muryp-md.link.check')
local createLink = require('nvim-muryp-md.link.create')
local configs    = require('nvim-muryp-md').configs

---@param args 'open'|'enter'
---@return nil - open/create link/show err
return function(args)
  local GET_LINK ---@type string|nil
  if args == 'open' then
    ---@diagnostic disable-next-line: cast-local-type
    GET_LINK = CheckLink.isLink()
    if GET_LINK then
      GET_LINK = GET_LINK.url
    end
  else
    GET_LINK = createLink()
  end
  if GET_LINK then
    local REGEX_RAW_LINK = "^https?://[%w-_%.%?%.:/%+=&]+"
    local isLink = string.match(GET_LINK, REGEX_RAW_LINK) ---@type string | nil strin will return raw link select
    -- change val by configs
    if isLink then
      vim.cmd(configs.link.openCmd .. ' ' .. GET_LINK)
      return
    end
    GET_LINK = configs.link.replaceFileLink(GET_LINK)
    -- check folder
    local FOLDER, FILE = GET_LINK:match("(.*/)(.*)")
    local isHaveFolder = ''
    if FOLDER then
      isHaveFolder = vim.fn.system('ls ' .. FOLDER)
    end
    if isHaveFolder:match('No such file or directory') then
      local isPush = vim.fn.input('Folder not found, want create it (Y/n) ? ') ---@type string
      if isPush ~= 'n' or isPush ~= 'N' then
        local CURRENT_FILE = vim.api.nvim_buf_get_name(0)
        local CURRENT_FOLDER = vim.fn.fnamemodify(CURRENT_FILE, ':h')
        local NEW_FOLDER = CURRENT_FOLDER .. '/' .. FOLDER
        vim.fn.mkdir(NEW_FOLDER, 'p')
        vim.cmd('e ' .. NEW_FOLDER .. FILE)
        return
      end
      vim.api.nvim_err_writeln("Cannot open, because folder doesn't exist")
      return
    end
    -- want create folder?
    vim.cmd('e ' .. GET_LINK)
  end
end
