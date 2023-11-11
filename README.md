[![License: Apache](https://img.shields.io/badge/License-Apache-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Neovim version](https://img.shields.io/badge/Neovim-0.8.x-green.svg)
![Lua version](https://img.shields.io/badge/Lua-5.4-yellow.svg)
[![Repo Size](https://img.shields.io/github/repo-size/muryp/muryp-link.nvim)](https://github.com/muryp/muryp-link.nvim)
[![Latest Release](https://img.shields.io/github/release/muryp/muryp-link.nvim)](https://github.com/muryp/muryp-link.nvim/releases/latest)
[![Last Commit](https://img.shields.io/github/last-commit/muryp/muryp-link.nvim)](https://github.com/muryp/muryp-link.nvim/commits/master)
[![Open Issues](https://img.shields.io/github/issues/muryp/muryp-link.nvim)](https://github.com/muryp/muryp-link.nvim/issues)

# Plugin Nvim MuryP Link
open url/path markdown, wiki, lsp hover, or url
## feature
- open url/path
- unlink md/wiki link
- open from hover lsp
## requirement
- nvim 0.8+ (recommendation)
## install
- lazy.nvim
```lua
{
  'muryp/muryp-link.nvim',
  config = function()
    require('muryp-link').setup({})
  end
}
```
## setup
```lua
require('muryp-link').setup({
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
})
```