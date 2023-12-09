local enter = require 'muryp-link.enter'

describe('enter link/text', function()
  vim.cmd 'e! example/link3.txt'
  it('create link on text', function()
    enter 'enter'
    local LINE_TEXT = vim.api.nvim_get_current_line() ---@type string - get text on current line
    _G.test('[text](text)', LINE_TEXT)
  end)
  local EXPECT_RESULT = {
    'example/LINK_MD.md',
    'example/LINK_MD2.md',
    'example/sub/LINK_MD.md',
    'example/sub/LINK_MD2.md',
    'example/sub/LINK_MD3.md',
    'example/link1.md',
  }
  for key, fileExpect in pairs(EXPECT_RESULT) do
    key = key + 1
    it('open link on line ' .. key, function()
      vim.cmd 'e! example/link3.txt'
      vim.api.nvim_win_set_cursor(0, { key, 1 })
      enter('enter', true)
      local getFile = vim.fn.expand '%:f'
      local result = string.match(getFile, '.*/(' .. fileExpect .. ')') or getFile
      _G.test(fileExpect, result)
    end)
  end
  vim.fn.system 'rm -rf example/sub'
end)
