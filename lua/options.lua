local opt=vim.opt

-- opt.number=true
opt.relativenumber=true

opt.tabstop=2
opt.autoindent=true
opt.shiftwidth=2
opt.expandtab=true
opt.breakindent=true

opt.termguicolors=true
opt.signcolumn="number"
vim.o.cursorline=true
opt.inccommand='split'
opt.confirm=true
opt.list=true
opt.listchars={
  trail='.',
	tab='->'
}
opt.undofile=false
opt.ignorecase=true
opt.smartcase=true
vim.g.have_nerd_font=true

vim.o.background="dark"
vim.cmd.colorscheme 'retrobox'

opt.splitright=true
opt.splitbelow=true

