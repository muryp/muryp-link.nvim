---@diagnostic disable: need-check-nil
local checkLink = require('muryp-link.check')
describe('checklink ', function()
  vim.cmd('e! example/link.txt')
  local TEST_CASE_FALSE = {
    { 1, 1 },
    { 7, 7 },
  }
  for _, val in pairs(TEST_CASE_FALSE) do
    it('is not raw link on line ' .. val[1] .. ' col ' .. val[2], function()
      vim.api.nvim_win_set_cursor(0, { val[1], val[2] })
      local result = checkLink.isLink()
      _G.test(nil, result)
    end)
  end
  local TEST_CASE_TRUE = {
    'https://domain.com',
    'https://www.domain.com',
    'http://domain.com',
    'http://www.my-domain.com',
    'http://www.blog.my-domain.com',
    'www.domain.com',
  }
  for key, val in pairs(TEST_CASE_TRUE) do
    it('is raw link on line ' .. key, function()
      vim.api.nvim_win_set_cursor(0, { key, 7 })
      local result = checkLink.isLink()
      _G.test(val, result.url)
    end)
  end
end)
describe('listLink ', function()
  vim.cmd('e! example/link.txt')
  local TEST_CASE_TRUE_MD = {
    [8] = { { 7, 25 } },
    [9] = { { 7, 25 }, { 27, 47 } },
    [10] = { { 7, 29 }, { 33, 53 } },
    [12] = { { 7, 42 } },
    [15] = { { 6, 19 }, { 25, 38 }, { 44, 57 } },
    [16] = { { 6, 24 }, { 30, 48 }, { 54, 72 } },
  }
  for line, value in pairs(TEST_CASE_TRUE_MD) do
    it('isMd on line ' .. line, function()
      vim.api.nvim_win_set_cursor(0, { line, 0 })
      local LINE_CONTENT = vim.api.nvim_get_current_line() ---@type string - get text on current line
      local result = checkLink.listLinkNum(LINE_CONTENT, 'md')
      for key, val in pairs(value) do
        _G.test(val[1], result[key].startCol)
        _G.test(val[2], result[key].endCol)
      end
    end)
  end
  local TEST_CASE_TRUE_WIKI = {
    [10] = { { 7, 21 }, { 55, 63 } },
    [11] = { { 7, 16 } },
  }
  for line, value in pairs(TEST_CASE_TRUE_WIKI) do
    it('isWiki on line ' .. line, function()
      vim.api.nvim_win_set_cursor(0, { line, 0 })
      local LINE_CONTENT = vim.api.nvim_get_current_line() ---@type string - get text on current line
      local result = checkLink.listLinkNum(LINE_CONTENT, 'wiki')
      for key, val in pairs(value) do
        _G.test(val[1], result[key].startCol)
        _G.test(val[2], result[key].endCol)
      end
    end)
  end
end)
describe('checkLinkMdWiki ', function()
  local TEST_CASE_TRUE = {
    { 8, 7, { text = 'this link', url = './link', isMdWiki = true, COL = { startCol = 7, endCol = 25 } } },
    { 9, 7, { text = 'this link', url = './link', isMdWiki = true, COL = { startCol = 7, endCol = 25 } } },
    { 9, 27, { text = 'this link2', url = './link2', isMdWiki = true, COL = { startCol = 27, endCol = 47 } } },
    { 10, 7, { text = '[th(is) link]', url = './link', isMdWiki = true, COL = { startCol = 7, endCol = 29 } } },
    { 10, 55, { text ='link3', url = 'link3', isMdWiki = true, COL = { startCol = 55, endCol = 63 } } },
    { 11, 7, { text ='thlink', url = 'thlink', isMdWiki = true, COL = { startCol = 7, endCol = 16 } } },
    { 15, 6, { text ='link1', url = 'link1', isMdWiki = true, COL = { startCol = 6, endCol = 19 } } },
    { 15, 25, { text ='link2', url = 'link2', isMdWiki = true, COL = { startCol = 25, endCol = 38 } } },
    { 15, 44, { text ='link3', url = 'link3', isMdWiki = true, COL = { startCol = 44, endCol = 57 } } },
    { 16, 6, { text ='text link1', url = 'link1', isMdWiki = true, COL = { startCol = 6, endCol = 24 } } },
    { 16, 30, { text ='text link2', url = 'link2', isMdWiki = true, COL = { startCol = 30, endCol = 48 } } },
    { 16, 54, { text ='text link3', url = 'link3', isMdWiki = true, COL = { startCol = 54, endCol = 72 } } },
    { 21, 15, { text ='link this', url = 'https://domain.com', isMdWiki = true, COL = { startCol = 1, endCol = 31 } } },
  }

  for _, val in pairs(TEST_CASE_TRUE) do
    it('on line ' .. val[1] .. ' col ' .. val[2], function()
      vim.api.nvim_win_set_cursor(0, { val[1], val[2] })
      local isLinkMdWiki = checkLink.isLink()
      _G.test(val[3].COL.startCol, isLinkMdWiki.COL.startCol)
      _G.test(val[3].COL.endCol, isLinkMdWiki.COL.endCol)
      _G.test(val[3].url, isLinkMdWiki.url)
      _G.test(val[3].isMdWiki, isLinkMdWiki.isMdWiki)
    end)
  end
end)