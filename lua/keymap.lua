local key = vim.keymap
local api = vim.api
local commenter = require("commenter")
vim.g.mapleader = ' '

local function clamp_col(text, col)
	local len = #text
	if col > len then
		return len
	end
	return col
end

local function move_line(delta)
	local buf = api.nvim_get_current_buf()
	local total = api.nvim_buf_line_count(buf)
	local cursor = api.nvim_win_get_cursor(0)
	local row, col = cursor[1], cursor[2]
	local dest = row + delta
	if dest < 1 or dest > total then
		return
	end
	local line = api.nvim_buf_get_lines(buf, row - 1, row, false)
	if #line == 0 then
		return
	end
	api.nvim_buf_set_lines(buf, row - 1, row, false, {})
	api.nvim_buf_set_lines(buf, dest - 1, dest - 1, false, line)
	local new_col = clamp_col(line[1], col)
	api.nvim_win_set_cursor(0, { dest, new_col })
end

local function duplicate_line(delta)
	local buf = api.nvim_get_current_buf()
	local cursor = api.nvim_win_get_cursor(0)
	local row, col = cursor[1], cursor[2]
	local line = api.nvim_buf_get_lines(buf, row - 1, row, false)
	if #line == 0 then
		line = { "" }
	end
	local insert_at = delta < 0 and (row - 1) or row
	api.nvim_buf_set_lines(buf, insert_at, insert_at, false, line)
	local target_row = row + (delta > 0 and 1 or 0)
	local new_col = clamp_col(line[1], col)
	api.nvim_win_set_cursor(0, { target_row, new_col })
end

local esc = api.nvim_replace_termcodes("<Esc>", true, false, true)

key.set("n","<leader>Q",":q<CR>")
key.set("n","<leader>|",":vsplit ")
key.set("n","<leader>-",":split ")

local o = {noremap=true,silent=true}
key.set("n","<C-/>",function()
	commenter.toggle_current()
end,o)
key.set("v","<C-/>",function()
	commenter.toggle_visual()
	api.nvim_feedkeys(esc, "n", true)
end,o)

key.set("n","<C-l>","<C-w>l",o)
key.set("n","<C-k>","<C-w>k",o)
key.set("n","<C-j>","<C-w>j",o)
key.set("n","<C-h>","<C-w>h",o)

key.set("n","<leader>t",":tabnew ",{noremap=true})
key.set("n","<leader>T",function()
  vim.cmd("tabclose")
  vim.notify("   Tab Closed", vim.log.levels.INFO)
end,o)
key.set("n","<A-h>",function()
  vim.cmd("tabprevious")
  vim.notify("   Swich Previous Tab ", vim.log.levels.INFO)
end,o)
key.set("n","<A-l>",function()
  vim.cmd("tabNext")
  vim.notify("   Swich Next Tab ", vim.log.levels.INFO)
end,o)

key.set({"n","i"},"<C-s>",function()
	vim.cmd("silent write")
	vim.api.nvim_echo({{" All Changes are Saved ","MoreMsg"}}, false, {})
end,o)

key.set("n","<A-Up>",function() move_line(-1) end,o)
key.set("n","<A-Down>",function() move_line(1) end,o)
key.set("n","<A-k>",function() duplicate_line(-1) end,o)
key.set("n","<A-j>",function() duplicate_line(1) end,o)
key.set("t","<Esc>","<C-\\><C-n>")
key.set("n","<C-`>",":vsplit | terminal<CR>",o)
key.set("n","<leader>/",":split | terminal<CR>",o)
