local LINK_DEFAULT_CONFIGS = require('muryp-link.configs')
local M                    = {}

M.configs                  = {
  link = LINK_DEFAULT_CONFIGS
}
-- M.check                    = require('muryp-link.check')
-- M.configs                  = require('muryp-link.configs')
-- M.create                   = require('muryp-link.create')
-- M.unlink                   = require('muryp-link.unlink')
-- M.enter                    = require('muryp-link.enter')('enter')
-- M.open                     = require('muryp-link.enter')('open')
return M