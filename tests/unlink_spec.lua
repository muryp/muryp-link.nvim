describe('unlink ', function()
  vim.cmd('e! example/link4.txt')
  local EXPECT_RESULT = {
    { 3,  'LINK_MD' },
    { 3,  'LINK_MD2.md' },
    { 3,  'sub/LINK_MD.md' },
    { 3,  './sub/LINK_MD2.md' },
    { 3,  '/example/sub/LINK_MD3.md' },
    { 3,  'text link1' },
    { 15, 'text link1' },
    { 3,  'https://example.com' },
    { 1,  'https://example.com' },
  }
  for key, expect in pairs(EXPECT_RESULT) do
    it('on line ' .. key, function()
      vim.api.nvim_win_set_cursor(0, { key, expect[1] })
      require('muryp-link.unlink')()
      local LINE_TEXT = vim.api.nvim_get_current_line() ---@type string - get text on current line
      _G.test(expect[2], LINE_TEXT)
    end)
  end
end)