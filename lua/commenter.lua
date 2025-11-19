local M = {}

local api = vim.api
local fn = vim.fn

local function get_comment_tokens()
  local cs = vim.bo.commentstring
  if not cs or cs == '' or not cs:find('%%s') then
    cs = '// %s'
  end
  local before, after = cs:match('^(.*)%%s(.*)$')
  before = before or '// '
  after = after or ''
  return before, after
end

local function split_indent(line)
  local indent, rest = line:match('^(%s*)(.*)$')
  return indent or '', rest or ''
end

local function try_uncomment(line, before, after)
  local indent, rest = split_indent(line)
  if rest == '' then
    return false, line
  end
  if before ~= '' then
    if rest:sub(1, #before) ~= before then
      return false, line
    end
    rest = rest:sub(#before + 1)
  end
  if after ~= '' then
    if rest:sub(-#after) ~= after then
      return false, line
    end
    rest = rest:sub(1, #rest - #after)
  end
  return true, indent .. rest
end

local function comment_line(line, before, after)
  local indent, rest = split_indent(line)
  if rest == '' then
    rest = ''
  end
  return indent .. before .. rest .. after
end

local function apply_toggle(start_line, end_line)
  local before, after = get_comment_tokens()
  local buf = api.nvim_get_current_buf()
  local lines = api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
  if vim.tbl_isempty(lines) then
    return
  end
  local all_commented = true
  local has_target = false
  local processed = {}
  for idx, line in ipairs(lines) do
    local commented, uncommented = try_uncomment(line, before, after)
    processed[idx] = { commented = commented, uncommented = uncommented, original = line }
    if line:match('%S') then
      has_target = true
      if not commented then
        all_commented = false
      end
    end
  end
  if not has_target then
    all_commented = false
  end
  local new_lines = {}
  for _, info in ipairs(processed) do
    if all_commented and info.commented then
      table.insert(new_lines, info.uncommented)
    else
      table.insert(new_lines, comment_line(info.original, before, after))
    end
  end
  api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, new_lines)
end

function M.toggle_current()
  local row = api.nvim_win_get_cursor(0)[1]
  apply_toggle(row, row)
end

function M.toggle_visual()
  local anchor = fn.getpos('v')
  local cursor_line = api.nvim_win_get_cursor(0)[1]
  local start_line = math.min(anchor[2], cursor_line)
  local end_line = math.max(anchor[2], cursor_line)
  if start_line <= 0 or end_line <= 0 then
    return
  end
  apply_toggle(start_line, end_line)
end

return M
