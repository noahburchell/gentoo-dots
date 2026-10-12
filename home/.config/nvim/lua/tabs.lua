local width = {
	asm = 8,
	c = 8,
	cpp = 8,
	diff = 8,
	dts = 8,
	go = 8,
	help = 8,
	kconfig = 8,
	ld = 8,
	make = 8,
	nasm = 8,
}

local spaces = {
	elm = true,
	fsharp = true,
	haskell = true,
	lhaskell = true,
	nim = true,
	yaml = true,
}

vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.softtabstop = 0

local ec = require('editorconfig').properties
ec.indent_style = nil
ec.indent_size = nil
ec.tab_width = nil

local function apply(buf)
	if not vim.api.nvim_buf_is_valid(buf) then return end
	local bo = vim.bo[buf]
	if bo.buftype ~= '' then return end
	bo.expandtab = spaces[bo.filetype] or false
	bo.tabstop = width[bo.filetype] or 4
	bo.shiftwidth = 0
	bo.softtabstop = 0
end

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('tabs', { clear = true }),
	callback = function(ev)
		vim.schedule(function() apply(ev.buf) end)
	end,
})
