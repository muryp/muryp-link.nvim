local CheckLink = require 'muryp-link.check'

return function()
  local CHECK_LINK = CheckLink.isLink()
  local line_num = vim.fn.line '.'
  if CHECK_LINK.text then
    vim.api.nvim_buf_set_text(
      0,
      line_num - 1,
      CHECK_LINK.COL.startCol - 1,
      line_num - 1,
      CHECK_LINK.COL.endCol,
      { CHECK_LINK.text }
    )
  end
end
