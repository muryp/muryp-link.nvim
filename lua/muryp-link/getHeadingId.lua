---@param headingId string
return function(headingId)
  local CURRENT_TEXT_TABLE = vim.api.nvim_buf_get_lines(0, 0, -1, true) ---@type string[]
  headingId = headingId:gsub('-', '.')
  for LINE_NUM, LINE_TEXT in pairs(CURRENT_TEXT_TABLE) do
    if string.match(string.lower(LINE_TEXT), '#* ' .. string.lower(headingId)) then
      return vim.cmd('normal! ' .. LINE_NUM .. 'G')
    end
  end
end
