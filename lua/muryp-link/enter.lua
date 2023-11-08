local CheckLink = require 'muryp-link.check'
local createLink = require 'muryp-link.create'
local configs = require('muryp-link').configs

---@param args 'open'|'enter'
---@param TEST true|nil
---@return nil - open/create link/show err
return function(args, TEST)
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
    local REGEX_RAW_LINK = '^https?://[%w-_%.%?%.:/%+=&]+'
    local isLink = string.match(GET_LINK, REGEX_RAW_LINK) ---@type string | nil strin will return raw link select
    -- change val by configs
    if isLink then
      vim.cmd(configs.openCmd .. ' ' .. GET_LINK)
      return
    end
    local regexPathFile = '(.*/)(.*)'
    local FOLDER ---@type string
    local FILE ---@type string
    local HOVER_LSP ---@type boolean
    if GET_LINK:match '^..*/' then
      local FOLDER_, FILE_ = GET_LINK:match(regexPathFile)
      FOLDER = FOLDER_
      FILE = FILE_
    else
      FOLDER = ''
      FILE = GET_LINK
    end
    FILE = configs.replaceFileLink(FILE)
    --- cek is not root folder
    local CURRENT_FOLDER = vim.fn.expand '%:h'
    if string.match(FOLDER, '^%/') then
      local gitRoot = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '') ---@type string
      FOLDER = gitRoot .. FOLDER
    elseif FOLDER:match('^file://') then
      HOVER_LSP = true
      FOLDER = FOLDER:gsub('^file://', '')
    else
      FOLDER = CURRENT_FOLDER .. '/' .. string.gsub(FOLDER, '^%./', '')
    end
    GET_LINK = FOLDER .. FILE
    local isHaveFolder = ''
    if FOLDER then
      isHaveFolder = vim.fn.system('ls ' .. FOLDER)
    end
    if isHaveFolder:match 'No such file or directory' then
      local isAddDir
      if TEST then
        isAddDir = 'y'
      else
        isAddDir = vim.fn.input 'Folder not found, want create it (Y/n) ? ' ---@type string
      end
      if isAddDir == 'n' or isAddDir == 'N' then
        vim.api.nvim_err_writeln "Cannot open, because folder doesn't exist"
      else
        vim.fn.mkdir(FOLDER, 'p')
        vim.cmd('e ' .. FOLDER .. FILE)
      end
    end
    if HOVER_LSP then
      local winid = vim.api.nvim_get_current_win()
      vim.api.nvim_win_close(winid, true)
    end
    vim.cmd('e ' .. GET_LINK)
  end
end