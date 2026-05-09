local opt=vim.opt

-- opt.number=true
opt.relativenumber=true

opt.tabstop=4
opt.softtabstop=4
opt.autoindent=true
opt.smartindent=true
opt.shiftwidth=4
opt.expandtab=false

opt.wrap=true
opt.linebreak=true
opt.breakindent=true
-- opt.showbreak="󱞩"
opt.showbreak=""

opt.termguicolors=true
opt.laststatus=3
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

vim.diagnostic.config({
	signs = true,
	underline = true,
	virtual_text = true,
	virtual_libes = false,
	float = {
		header = "",
		border = 'rounded',
		focusable = true,
	}
})
