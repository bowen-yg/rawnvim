local M = {}

local function clamp_col(line, col)
  return math.min(col, #line)
end

local function leave_visual_mode()
  vim.cmd.normal({
    args = { vim.api.nvim_replace_termcodes("<Esc>", true, false, true) },
    bang = true,
  })
end

local function restore_linewise_selection(win, anchor, cursor)
  -- 先把光标放到 Visual 选择的锚点
  vim.api.nvim_win_set_cursor(win, anchor)

  -- 进入 Visual Line 模式
  vim.cmd.normal({
    args = { "V" },
    bang = true,
  })

  -- 将活动端移动到目标位置
  vim.api.nvim_win_set_cursor(win, cursor)
end

function M.move_block(delta)
  if delta == 0 then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  local cursor = vim.api.nvim_win_get_cursor(win)
  local cursor_row = cursor[1]
  local cursor_col = cursor[2]

  -- getpos("v") 返回：
  -- { buffer_number, line, column, offset }
  -- 其中 column 是 1-based
  local visual_pos = vim.fn.getpos("v")
  local anchor_row = visual_pos[2]
  local anchor_col = math.max(visual_pos[3] - 1, 0)

  local first_row = math.min(cursor_row, anchor_row)
  local last_row = math.max(cursor_row, anchor_row)
  local cursor_at_bottom = cursor_row >= anchor_row

  local line_count = vim.api.nvim_buf_line_count(buf)

  -- 边界检查
  if delta < 0 and first_row == 1 then
    return
  end

  if delta > 0 and last_row == line_count then
    return
  end

  leave_visual_mode()

  local new_first
  local new_last

  if delta < 0 then
    -- API 行号为 0-based。
    --
    -- 获取：
    --   上一行 + 选中块
    local lines = vim.api.nvim_buf_get_lines(
      buf,
      first_row - 2,
      last_row,
      false
    )

    -- 将：
    --   previous, selected...
    -- 调整为：
    --   selected..., previous
    local previous = table.remove(lines, 1)
    table.insert(lines, previous)

    vim.api.nvim_buf_set_lines(
      buf,
      first_row - 2,
      last_row,
      false,
      lines
    )

    new_first = first_row - 1
    new_last = last_row - 1
  else
    -- 获取：
    --   选中块 + 下一行
    local lines = vim.api.nvim_buf_get_lines(
      buf,
      first_row - 1,
      last_row + 1,
      false
    )

    -- 将：
    --   selected..., next
    -- 调整为：
    --   next, selected...
    local next_line = table.remove(lines)
    table.insert(lines, 1, next_line)

    vim.api.nvim_buf_set_lines(
      buf,
      first_row - 1,
      last_row + 1,
      false,
      lines
    )

    new_first = first_row + 1
    new_last = last_row + 1
  end

  -- 保持原来选择方向：
  -- 光标原来在底部，移动后仍在底部；
  -- 光标原来在顶部，移动后仍在顶部。
  local new_cursor_row
  local new_anchor_row

  if cursor_at_bottom then
    new_anchor_row = new_first
    new_cursor_row = new_last
  else
    new_anchor_row = new_last
    new_cursor_row = new_first
  end

  -- 防止原列超过目标行长度
  local anchor_line =
    vim.api.nvim_buf_get_lines(buf, new_anchor_row - 1, new_anchor_row, false)[1]
    or ""

  local cursor_line =
    vim.api.nvim_buf_get_lines(buf, new_cursor_row - 1, new_cursor_row, false)[1]
    or ""

  restore_linewise_selection(
    win,
    {
      new_anchor_row,
      clamp_col(anchor_line, anchor_col),
    },
    {
      new_cursor_row,
      clamp_col(cursor_line, cursor_col),
    }
  )
end

return M
