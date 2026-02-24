local opt=vim.opt

-- opt.number=true
opt.relativenumber=true

opt.tabstop=4
opt.softtabstop=4
opt.autoindent=true
opt.smartindent=true
opt.shiftwidth=4
opt.expandtab=false
opt.breakindent=true

opt.termguicolors=true
opt.showmode=false
opt.signcolumn="number"
vim.o.cursorline=true
opt.inccommand='split'
opt.clipboard="unnamedplus"
opt.confirm=true
opt.list=true
opt.listchars={
	trail='_',
	tab='->',
	space='.',
	--eol=''
}
opt.undofile=false
opt.ignorecase=true
opt.smartcase=true
vim.g.have_nerd_font=true

vim.o.background="dark"

opt.splitright=true
opt.splitbelow=true

