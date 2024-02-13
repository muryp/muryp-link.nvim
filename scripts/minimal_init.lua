vim.cmd [[
set rtp+=.
set rtp+=./plenary.nvim/
set noswapfile
]]
_G.space_opts = function()
  vim.o.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.cmd '%retab!'
end
_G.tab_opts = function()
  vim.o.expandtab = false
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.cmd '%retab!'
end
_G.test = function(expect, result)
  if expect ~= result then
    print('Expect : ' .. vim.inspect(expect))
    print('result : ' .. vim.inspect(result))
    error()
  end
end
_G.space_opts()

require('muryp-link').setup {}