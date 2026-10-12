local g = {
	fg = '#e4e4ef',
	fg1 = '#f4f4ff',
	fg2 = '#f5f5f5',
	white = '#ffffff',
	bg_1 = '#101010',
	bg = '#181818',
	bg1 = '#282828',
	bg2 = '#453d41',
	bg3 = '#484848',
	bg4 = '#52494e',
	red_1 = '#c73c3f',
	red = '#f43841',
	red1 = '#ff4f58',
	green = '#73c936',
	yellow = '#ffdd33',
	brown = '#cc8c3c',
	quartz = '#95a99f',
	niagara_2 = '#303540',
	niagara_1 = '#565f73',
	niagara = '#96a6c8',
	wisteria = '#9e95c7',
}

local x = {
	green_bright = '#89e051',
	yellow_bright = '#fff554',
	niagara_bright = '#acbcdf',
	wisteria_bright = '#b4abde',
	quartz_bright = '#abbfb5',
	green_tint = '#283422',
	niagara_tint = '#2c2e33',
	niagara_tint2 = '#3a3e47',
	red_tint = '#3c2220',
	green_mid = '#497330',
	niagara_mid = '#596172',
	red_mid = '#8a3130',
}

require 'scheme'('gruber', {
	bg = g.bg,
	surface = g.bg1,
	raised = g.bg2,
	select = g.bg3,
	hover = g.bg4,
	border = g.bg4,
	thumb = g.bg_1,
	fg = g.fg,
	bright = g.white,
	cursor = g.yellow,
	mid = g.quartz,
	dim = g.niagara_1,
	faint = g.bg4,
	error = g.red,
	warn = g.yellow,
	ok = g.green,
	info = g.niagara,
	add = g.green,
	change = g.niagara,
	delete = g.red1,
	staged_add = x.green_mid,
	staged_change = x.niagara_mid,
	staged_delete = x.red_mid,
	diff_add = x.green_tint,
	diff_change = x.niagara_tint,
	diff_text = x.niagara_tint2,
	diff_delete = x.red_tint,
	diff_delete_fg = x.red_mid,
	search = g.niagara_1,
	search_fg = g.fg1,
	cursearch = g.fg2,
	substitute = g.red,
	internal_error = g.red_1,
	spell_rare = g.wisteria,
	spell_local = g.quartz,
	mode = {
		normal = g.niagara,
		insert = g.green,
		visual = g.wisteria,
		replace = g.red,
		command = g.yellow,
		other = g.quartz,
	},
	ansi = {
		g.bg3, g.red_1, g.green, g.yellow, g.niagara, g.wisteria, g.quartz, g.fg,
		g.bg4, g.red1, x.green_bright, x.yellow_bright, x.niagara_bright, x.wisteria_bright, x.quartz_bright, g.white,
	},
	syntax = {
		comment = g.brown,
		string = g.green,
		escape = g.green,
		regexp = g.green,
		number = g.fg,
		keyword = g.yellow,
		control = g.yellow,
		type = g.quartz,
		func = g.niagara,
		variable = g.fg,
		constant = g.quartz,
		label = g.fg,
		tagdelim = g.fg,
		list = g.quartz,
		invalid = g.red,
		builtin = g.yellow,
		macro = g.quartz,
		tag = g.niagara,
		tag_attribute = g.fg1,
		heading = g.niagara,
		diff_plus = g.green,
		diff_minus = g.red1,
		diff_delta = g.yellow,
	},
})

local set = vim.api.nvim_set_hl

for _, name in ipairs {
	'Statement', 'Conditional', 'Repeat', 'Keyword', 'Exception', 'StorageClass', 'Structure', 'Typedef', 'Boolean',
	'@keyword', '@keyword.coroutine', '@keyword.function', '@keyword.operator', '@keyword.type', '@keyword.modifier',
	'@keyword.repeat', '@keyword.return', '@keyword.debug', '@keyword.exception', '@keyword.conditional',
	'@boolean', '@variable.builtin', '@constant.builtin',
} do
	set(0, name, { fg = g.yellow, bold = true })
end

for _, name in ipairs { 'PreProc', 'Include', 'Define', 'PreCondit', '@keyword.import', '@keyword.directive', '@keyword.directive.define' } do
	set(0, name, { fg = g.quartz })
end

set(0, '@type.builtin', { fg = g.quartz })
set(0, '@function.builtin', { fg = g.yellow })
set(0, '@function.call', { fg = g.fg })
set(0, '@function.method.call', { fg = g.fg })
set(0, '@markup.heading', { fg = g.niagara, bold = true })

set(0, '@lsp.type.function', {})
set(0, '@lsp.type.method', {})

set(0, 'CursorLineNr', { fg = g.yellow })
set(0, 'StatusLine', { fg = g.white, bg = g.bg1 })
set(0, 'StatusLineNC', { fg = g.quartz, bg = g.bg1 })

set(0, 'PmenuSel', { fg = g.fg, bg = g.bg_1 })
set(0, 'PmenuKindSel', { fg = g.fg, bg = g.bg_1 })
set(0, 'PmenuMatch', { fg = g.green, bg = g.bg1 })
set(0, 'PmenuMatchSel', { fg = g.green, bg = g.bg_1 })
set(0, 'PmenuExtra', { fg = g.brown, bg = g.bg1 })
set(0, 'PmenuExtraSel', { fg = g.brown, bg = g.bg_1 })
