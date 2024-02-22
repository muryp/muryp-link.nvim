local LINK_DEFAULT_CONFIGS = require 'muryp-link.configs'
local M = {}

M.configs = require 'muryp-link.configs'
M.unlink = require 'muryp-link.unlink'
M.configs = LINK_DEFAULT_CONFIGS

---@class args table
---@field on_attach function<boolean>
---@field openCmd string
---@field maps {enter:string,unlink:string}
---@field replaceFileLink fun(args:string):string
---@field replaceTexttoLink fun(args:string):string
---@param args args|Object
M.setup = function(args)
  if args.openCmd then
    M.configs.openCmd = args.openCmd
  end
  if args.on_attach then
    M.configs.on_attach = args.on_attach
  end
  if args.replaceFileLink then
    M.configs.replaceFileLink = args.replaceFileLink
  end
  if args.replaceTexttoLink then
    M.configs.replaceTexttoLink = args.replaceTexttoLink
  end
  if args.maps then
    if args.maps.enter then
      M.configs.maps.enter = args.maps.enter
    end
    if args.maps.unlink then
      M.configs.maps.unlink = args.maps.unlink
    end
  end
  vim.keymap.set('n', M.configs.maps.unlink, function()
    M.unlink()
  end)
  vim.keymap.set('n', M.configs.maps.enter, function()
    local FILE_TYPE = vim.bo.filetype
    if FILE_TYPE == 'qf' then
      return '<CR>'
    end
    return ":lua require('muryp-link.enter')('enter')<CR>"
  end, { expr = true, replace_keycodes = true, silent = true })
  vim.keymap.set('v', M.configs.maps.visual, ":lua require('muryp-link.create')(true)<CR>")
end

return M