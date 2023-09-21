local createLink = require('muryp-link.create')

--use configs
describe('create link ', function()
  vim.cmd('e! example/link2.txt')
  local RESULT_TRUE = {
    { 1, 1,  '[hello](hello) https://domain.com end', nil },
    { 1, 1,  '[hello](hello) https://domain.com end', 'hello' },
    { 1, 15, '[hello](hello) https://domain.com end', nil},
    { 1, 16, '[hello](hello) https://domain.com end', 'https://domain.com' },
    { 2, 1,  '[[WIKI_LINK]]',                         'WIKI_LINK' },
  }
  for _, val in pairs(RESULT_TRUE) do
    it('on line ' .. val[1] .. ' col ' .. val[2], function()
      vim.api.nvim_win_set_cursor(0, { val[1], val[2] })
      local result = createLink()
      local LINE_TEXT = vim.api.nvim_get_current_line() ---@type string - get text on current line
      _G.test(val[3], LINE_TEXT)
      print(result)
      _G.test(val[4], result)
    end)
  end
end)