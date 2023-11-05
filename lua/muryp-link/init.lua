local LINK_DEFAULT_CONFIGS = require 'muryp-link.configs'
local M = {}

M.configs = LINK_DEFAULT_CONFIGS

---@class args table
---@field on_attach function<boolean>
---@field openCmd string
---@field replaceFileLink fun(args:string):string
---@field replaceTexttoLink fun(args:string):string
---@param args args
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
end
M.check                    = require('muryp-link.check')
M.configs                  = require('muryp-link.configs')
M.create                   = require('muryp-link.create')
M.unlink                   = require('muryp-link.unlink')
M.enter                    = require('muryp-link.enter')('enter')
M.open                     = require('muryp-link.enter')('open')
return M