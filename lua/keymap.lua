---@diagnostic disable: undefined-global
local key = vim.keymap
local api = vim.api
local commenter = require("config.commenter")
local move = require("config.move")
local new_move = require("config.new_move")
vim.g.mapleader = ' '

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

key.set("n","<A-h>",function()
  vim.cmd("tabprevious")
  vim.notify("   Swich Previous Tab ", vim.log.levels.INFO)
end,o)
key.set("n","<A-l>",function()
  vim.cmd("tabnext")
  vim.notify("   Swich Next Tab ", vim.log.levels.INFO)
end,o)

key.set({"n","i"},"<C-s>",function()
	vim.cmd("silent write")
	vim.api.nvim_echo({{" All Changes are Saved ","MoreMsg"}}, false, {})
end,o)

key.set({"n","x"},"<A-Up>",function() new_move.move_block(-1) end,o)
key.set({"n","x"},"<A-Down>",function() new_move.move_block(1) end,o)
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

key.set("n","<A-f>",":lua require('fzf-lua')<CR>",o)
key.set("n","L",":Lazy<CR>",o)
key.set("n","<leader>f",":FzfLua files<CR>",o)
key.set("n","<leader>b",":FzfLua buffers<CR>",o)
key.set("n","<leader>l",":FzfLua blines<CR>",o)
