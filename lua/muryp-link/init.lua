local M   = {}
M.check   = require('nvim-muryp-md.link.check')
M.configs = require('nvim-muryp-md.link.configs')
M.create  = require('nvim-muryp-md.link.create')
M.unlink  = require('nvim-muryp-md.link.unlink')
M.enter   = require('nvim-muryp-md.link.enter')('enter')
M.open    = require('nvim-muryp-md.link.enter')('open')
return M
