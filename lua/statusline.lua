local M = {}

local api = vim.api
local mode_names = {
	n = "NORMAL",
	no = "OP",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
	i = "INSERT",
	R = "REPLACE",
	r = "REPLACE",
	c = "COMMAND",
	["!"] = "SHELL",
	t = "    ",
  nt="  󰾉  ",
  ix="    ",
  ic="  󰕲  "
}

local function format_mode()
	local mode = api.nvim_get_mode().mode
	return mode_names[mode] or mode
end

local cached_time = os.date("%H:%M")
local apply_statusline

local function refresh_time()
	cached_time = os.date("%H:%M")
	if apply_statusline then
		apply_statusline()
	end
	api.nvim__redraw({ statusline = true })
end

local function setup_timer()
	if M.timer then
		return
	end
	M.timer = vim.loop.new_timer()
	M.timer:start(0, 60000, vim.schedule_wrap(refresh_time))
end

local function statusline()
	local left = table.concat({
		"  ", format_mode(), "  ",
		"%#Comment#",
		" ", " %f %m  %L",
	})
	local right = table.concat({
		"%#Normal#",
		"|%l:%c|   %P ", " ",cached_time, " ",
	})
	return table.concat({ left, "%=", right })
end

apply_statusline = function()
    vim.o.statusline = statusline()
end

-- 不在模块加载时自动注册/启动；改成显式 setup
M.setup = function()
    local group = api.nvim_create_augroup("custom_statusline", { clear = true })
    api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter", "ModeChanged" }, {
        group = group,
        callback = apply_statusline,
    })
    setup_timer()
    apply_statusline()
end

return M
