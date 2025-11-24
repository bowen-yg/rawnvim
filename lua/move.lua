---@diagnostic disable: undefined-global
local M = {}

local function clamp_col(text, col)
	local len = #text
	if col > len then
		return len
	end
	return col
end

function M.move_line(delta)
	local row = vim.fn.line(".")
	local last_line = vim.fn.line("$")

	if delta > 0 then
		if row < last_line then
			vim.cmd("move +1")
		end
	elseif delta < 0 then
		if row > 1 then
			vim.cmd("move -2")
		end
	end
end

function M.move_block(delta)
	local cursor_row = vim.fn.line(".")
	local v_row = vim.fn.line("v")
	local s_row = v_row
	local e_row = cursor_row

	local cursor_at_bottom = (cursor_row >= v_row)

	if s_row > e_row then
		s_row, e_row = e_row, s_row
	end

	vim.cmd("normal! " .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true))

	local last_line = vim.fn.line("$")

	if delta > 0 then
		if e_row < last_line then
			vim.cmd(string.format("%d,%dmove %d", s_row, e_row, e_row + 1))
			local new_s = s_row + 1
			local new_e = e_row + 1
			if cursor_at_bottom then
				vim.cmd("normal! " .. new_s .. "G")
				vim.cmd("normal! V")
				vim.cmd("normal! " .. new_e .. "G")
			else
				vim.cmd("normal! " .. new_e .. "G")
				vim.cmd("normal! V")
				vim.cmd("normal! " .. new_s .. "G")
			end
		end
	elseif delta < 0 then
		if s_row > 1 then
			vim.cmd(string.format("%d,%dmove %d", s_row, e_row, s_row - 2))
			local new_s = s_row - 1
			local new_e = e_row - 1
			if cursor_at_bottom then
				vim.cmd("normal! " .. new_s .. "G")
				vim.cmd("normal! V")
				vim.cmd("normal! " .. new_e .. "G")
			else
				vim.cmd("normal! " .. new_e .. "G")
				vim.cmd("normal! V")
				vim.cmd("normal! " .. new_s .. "G")
			end
		end
	end
end

function M.duplicate_line(delta)
	local buf = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1], cursor[2]
	local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)
	if #line == 0 then
		line = { "" }
	end
	local insert_at = delta < 0 and (row - 1) or row
	vim.api.nvim_buf_set_lines(buf, insert_at, insert_at, false, line)
	local target_row = row + (delta > 0 and 1 or 0)
	local new_col = clamp_col(line[1], col)
	vim.api.nvim_win_set_cursor(0, { target_row, new_col })
end

function M.duplicate_block(delta)
	local cursor_row = vim.fn.line(".")
	local v_row = vim.fn.line("v")
	local s_row = v_row
	local e_row = cursor_row

	local cursor_at_bottom = (cursor_row >= v_row)

	if s_row > e_row then
		s_row, e_row = e_row, s_row
	end

	vim.cmd("normal! " .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true))

	local lines = vim.api.nvim_buf_get_lines(0, s_row - 1, e_row, false)
	local new_s, new_e

	if delta > 0 then
		vim.api.nvim_buf_set_lines(0, e_row, e_row, false, lines)
		new_s = e_row + 1
		new_e = e_row + #lines
	else
		vim.api.nvim_buf_set_lines(0, s_row - 1, s_row - 1, false, lines)
		new_s = s_row
		new_e = s_row + #lines - 1
	end

	vim.cmd(string.format("normal! %dG", new_s))
	vim.cmd("normal! V")
	vim.cmd(string.format("normal! %dG", new_e))

	if not cursor_at_bottom and new_s ~= new_e then
		vim.cmd("normal! o")
	end
end

return M
