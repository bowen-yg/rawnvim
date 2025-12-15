---@diagnostic disable: undefined-global
local key = vim.keymap
local api = vim.api
local commenter = require("config.commenter")
local move = require("config.move")
vim.g.mapleader = ' '

local register_win

local function show_registers_float()
	if register_win and api.nvim_win_is_valid(register_win) then
		api.nvim_win_close(register_win, true)
	end

	local output = vim.fn.execute("registers")
	local lines = vim.split(output, "\n", { trimempty = true })
	if #lines == 0 then
		lines = { "No registers available" }
	end

	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, #line)
	end
	width = math.max(30, math.min(width + 2, math.floor(vim.o.columns * 0.6)))

	local available_height = math.max(5, vim.o.lines )
	local height = math.min(#lines, available_height)
	local row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1)
	local col = math.max(1, math.floor((vim.o.columns - width) / 2))

	local buf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	api.nvim_buf_set_option(buf, "filetype", "vim")
	api.nvim_buf_set_option(buf, "modifiable", true)
	api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	api.nvim_buf_set_option(buf, "modifiable", false)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].swapfile = false

	register_win = api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	local close_opts = { noremap = true, silent = true, nowait = true }
	api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>close<CR>", close_opts)
	api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<Cmd>close<CR>", close_opts)
end

local esc = api.nvim_replace_termcodes("<Esc>", true, false, true)

key.set("n","<leader>q",":q<CR>",{noremap=true})
key.set("n","<leader>Q",":qall<CR>",{noremap=true})
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

key.set({"n","i"},"<A-h>",function()
  vim.cmd("tabprevious")
  vim.notify("   Swich Previous Tab ", vim.log.levels.INFO)
end,o)
key.set({"n","i"},"<A-l>",function()
  vim.cmd("tabNext")
  vim.notify("   Swich Next Tab ", vim.log.levels.INFO)
end,o)

key.set({"n","i"},"<C-s>",function()
	vim.cmd("silent write")
	vim.api.nvim_echo({{" All Changes are Saved ","MoreMsg"}}, false, {})
end,o)

key.set("n","<A-Up>",function() move.move_line(-1) end,o)
key.set("n","<A-Down>",function() move.move_line(1) end,o)
key.set("v","<A-Up>",function() move.move_block(-1) end,o)
key.set("v","<A-Down>",function() move.move_block(1) end,o)
key.set("n","<A-k>",function() move.duplicate_line(-1) end,o)
key.set("n","<A-j>",function() move.duplicate_line(1) end,o)
key.set("v","<A-k>",function() move.duplicate_block(-1) end,o)
key.set("v","<A-j>",function() move.duplicate_block(1) end,o)
key.set("t","<Esc>","<C-\\><C-n>")
key.set("n","<Esc>",function()
  vim.cmd("nohlsearch")
  vim.notify("  󰹏 cancel high light   ")
end,o)
key.set("n","<C-`>",":vsplit | terminal<CR>",o)
key.set("n","<leader>/",":split | terminal<CR>",o)
-- key.set("n","<C-<leader>>","<C-x>",o)
key.set("i", "<Up>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>"
end, { noremap = true, silent = true, expr = true })

key.set("i", "<Down>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>"
end, { noremap = true, silent = true, expr = true })

key.set("n","<A-r>",show_registers_float,o)
key.set("n","<A-f>",":lua require('fzf-lua')<CR>",o)
key.set("n","L",":Lazy<CR>",o)
