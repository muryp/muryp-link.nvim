local createLink = require 'muryp-link.create'

--use configs
describe('create link ', function()
  vim.cmd 'e! example/link2.txt'
  local RESULT_TRUE = {
    { 1,  1,  '[hello](hello) https://domain.com end', nil },
    { 1,  1,  '[hello](hello) https://domain.com end', 'hello' },
    { 1,  16, '[hello](hello) https://domain.com end', 'https://domain.com' },
    { 2,  1,  '[[WIKI_LINK]]',                         'WIKI_LINK' },
    { 3, 4,  'LInk this',                             nil },
    { 3, 6,  'LInk [this](this)',                     nil },
    { 3, 6,  'LInk [this](this)',                     'this' },

  }
  for _, val in pairs(RESULT_TRUE) do
    local Col, Row, LineTest, Link = unpack(val)
    it('on line ' .. Col .. ' row ' .. Row, function()
      vim.api.nvim_win_set_cursor(0, { Col, Row })
      local result = createLink()
      local LINE_NOW = vim.api.nvim_get_current_line() ---@type string - get text on current line
      _G.test(LineTest, LINE_NOW)
      _G.test(Link, result)
    end)
  end
end)