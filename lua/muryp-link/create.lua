local checkLink = require 'muryp-link.check'
local configs = require('muryp-link').configs

---merge table into one
---@param table table[] - exam = {table1,table2,table3}
local function mergeTable(table)
  local MERGE_TABLE = {}
  for i = 1, #table do
    if table[i] == nil then
      return false
    end
    for j = 1, #table[i] do
      MERGE_TABLE[#MERGE_TABLE + 1] = table[i][j]
    end
  end
  return MERGE_TABLE
end
---@param TABLE_LINK_MD_WIKI {startCol:integer, endCol:integer}[]|false
---@param startCol number
---@param endCol number
---@return {startCol:number,endCol:number}|nil
local function cekNotConflictWithMdWiki(startCol, endCol, TABLE_LINK_MD_WIKI)
  local CURRENT_LINE = vim.fn.col '.'
  if TABLE_LINK_MD_WIKI == false then
    return
  end
  local CURRENT_LOOP = 1
  ---loop list link and slice range
  local function loopCek()
    local LINK_MD_WIKI = TABLE_LINK_MD_WIKI[CURRENT_LOOP]
    CURRENT_LOOP = CURRENT_LOOP + 1
    if LINK_MD_WIKI == nil then
      return
    end
    local isTableOnRange = (LINK_MD_WIKI.startCol > startCol and LINK_MD_WIKI.startCol < endCol)
      or (LINK_MD_WIKI.endCol > startCol and LINK_MD_WIKI.endCol < endCol)
    local isOnFirst = LINK_MD_WIKI.startCol >= endCol

    if isTableOnRange and isOnFirst then
      endCol = LINK_MD_WIKI.startCol - 1
      return
    end
    local isOnSecond = LINK_MD_WIKI.endCol > startCol
    if isTableOnRange and isOnSecond then
      ---cek is current cursor in front of lastCol link
      local isOnFrontLink = LINK_MD_WIKI.startCol > CURRENT_LINE
      ---cek is current cursor in behind lastCol link
      local isOnBackLink = LINK_MD_WIKI.endCol < CURRENT_LINE
      if isOnFrontLink then
        endCol = LINK_MD_WIKI.startCol - 1
        return loopCek()
      end
      if isOnBackLink then
        startCol = LINK_MD_WIKI.endCol + 1
        return loopCek()
      end
      return loopCek()
    end
    return loopCek()
  end
  loopCek()
  return { startCol = startCol, endCol = endCol }
end

local getText = function()
  local LINE_CONTENT = vim.api.nvim_get_current_line() ---@type string
  local CURRENT_COL = vim.fn.col '.' ---@type number
  if #LINE_CONTENT == 0 then
    return
  end
  local startCol ---@type number
  while CURRENT_COL > 0 do
    local PREV_COL = CURRENT_COL - 1
    local char = LINE_CONTENT:sub(PREV_COL, PREV_COL)
    startCol = CURRENT_COL
    if char == ' ' then
      break
    end
    CURRENT_COL = PREV_COL
  end
  CURRENT_COL = vim.fn.col '.'
  local endCol ---@type number
  while CURRENT_COL <= #LINE_CONTENT do
    local NEXT_COL = CURRENT_COL + 1
    local char = LINE_CONTENT:sub(NEXT_COL, NEXT_COL)
    endCol = CURRENT_COL
    if char == ' ' then
      break
    end
    CURRENT_COL = NEXT_COL
  end
  local LIST_MD_LINK = checkLink.listLinkNum(LINE_CONTENT, 'md')
  local LIST_WIKI_LINK = checkLink.listLinkNum(LINE_CONTENT, 'wiki')
  local TABLE_MD_WIKI = mergeTable { LIST_MD_LINK, LIST_WIKI_LINK } ---@type {startCol:integer, endCol:integer}[]|false
  local isConflict = cekNotConflictWithMdWiki(startCol, endCol, TABLE_MD_WIKI)
  if isConflict then
    startCol = isConflict.startCol
    endCol = isConflict.endCol
    local val = LINE_CONTENT:sub(startCol, endCol)
    if val then
      local result = { startCol = startCol, endCol = endCol, val = val }
      return result
    end
    return
  end
end

local function get_current_line_and_column_text()
  -- Get the current line number and column
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- Get the text of the current line
  local line_text = vim.api.nvim_get_current_line()
  -- Get the character at the specified column
  local char = line_text:sub(col, col)
  return char
end

---@return string|nil - return link url/file
local function createLink()
  if get_current_line_and_column_text() == ' ' then
    return
  end
  local CHEK_LINK = checkLink.isLink()
  -- is cursor is link
  if CHEK_LINK then
    return CHEK_LINK.url
  end
  local TEXT = getText()
  -- is cursor is not link
  if TEXT then
    local line_num = vim.fn.line '.'
    -- change val by configs
    TEXT.val = configs.replaceTexttoLink(TEXT.val)
    vim.api.nvim_buf_set_text(0, line_num - 1, TEXT.startCol - 1, line_num - 1, TEXT.endCol, { TEXT.val })
  end
end
return createLink
