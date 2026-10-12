local c = {
	[0] = '#000000',
	'#aa0000',
	'#00aa00',
	'#aa5500',
	'#0000aa',
	'#aa00aa',
	'#00aaaa',
	'#aaaaaa',
	'#555555',
	'#ff5555',
	'#55ff55',
	'#ffff55',
	'#5555ff',
	'#ff55ff',
	'#55ffff',
	'#ffffff',
}

local set = vim.api.nvim_set_hl

local function hl(name, fg, bg, attr, sp)
	local s = {}
	if fg then
		s.fg, s.ctermfg = c[fg], fg
	end
	if bg then
		s.bg, s.ctermbg = c[bg], bg
	end
	if attr then
		for k, v in pairs(attr) do
			s[k] = v
		end
		s.cterm = attr
	end
	if sp then s.sp = c[sp] end
	set(0, name, s)
end

local function link(name, to) set(0, name, { link = to }) end

vim.cmd.highlight 'clear'
if vim.g.syntax_on then vim.cmd.syntax 'reset' end
vim.o.background = 'dark'
vim.g.colors_name = 'vt'

for i = 0, 15 do
	vim.g['terminal_color_' .. i] = c[i]
end

local ul = { underline = true }
local curl = { undercurl = true }

hl('Normal', 7, 0)
hl('NormalFloat', 7, 0)
hl('FloatBorder', 8, 0)
hl('FloatTitle', 15, 0)
hl('FloatFooter', 8, 0)
hl('Cursor', 0, 7)
link('lCursor', 'Cursor')
link('CursorIM', 'Cursor')
hl 'CursorLine'
hl('CursorLineNr', 11)
hl('ColorColumn', nil, 4)
link('CursorColumn', 'ColorColumn')
hl('LineNr', 8)
hl('SignColumn', 8)
hl('FoldColumn', 8)
hl('Folded', 14, 4)
hl('NonText', 8)
hl('SpecialKey', 8)
hl('Conceal', 8)
hl('WinSeparator', 8)
hl('StatusLine', 0, 7)
hl('StatusLineNC', 7, 8)
hl('TabLine', 7, 8)
hl('TabLineSel', 0, 7)
hl('TabLineFill', nil, 0)
hl('WinBar', 15)
hl('WinBarNC', 7)
hl('Visual', 0, 7)
hl('Search', 15, 3)
hl('CurSearch', 0, 11)
hl('IncSearch', 0, 11)
hl('Substitute', 15, 1)
hl('MatchParen', 0, 6)
hl('QuickFixLine', 11)
hl('Pmenu', 7, 4)
hl('PmenuSel', 0, 6)
hl('PmenuKind', 10, 4)
hl('PmenuKindSel', 0, 6)
hl('PmenuExtra', 14, 4)
hl('PmenuExtraSel', 0, 6)
hl('PmenuMatch', 11, 4)
hl('PmenuMatchSel', 0, 6, ul)
hl('PmenuSbar', nil, 4)
hl('PmenuThumb', nil, 6)
link('WildMenu', 'PmenuSel')
hl('Directory', 12)
hl('Title', 15)
hl('ErrorMsg', 9)
hl('WarningMsg', 11)
hl('MoreMsg', 10)
hl('ModeMsg', 15)
hl('Question', 10)
hl('OkMsg', 10)
hl('NvimInternalError', 15, 1)
hl('SpellBad', nil, nil, curl, 9)
hl('SpellCap', nil, nil, curl, 11)
hl('SpellRare', nil, nil, curl, 13)
hl('SpellLocal', nil, nil, curl, 14)
hl('DiffAdd', 10)
hl('DiffChange', 11)
hl('DiffDelete', 9)
hl('DiffText', 0, 11)
hl('Added', 10)
hl('Changed', 11)
hl('Removed', 9)

hl('Comment', 6)
hl('Constant', 13)
hl('String', 13)
hl('Character', 13)
hl('Number', 13)
hl('Boolean', 13)
hl('Float', 13)
hl('Identifier', 7)
hl('Function', 15)
hl('Statement', 11)
hl('Operator', 7)
hl('PreProc', 12)
hl('Type', 10)
hl('StorageClass', 2)
hl('Special', 9)
hl('Delimiter', 7)
hl('Tag', 11)
hl('Underlined', 12, nil, ul)
hl('Ignore', 8)
hl('Error', 15, 1)
hl('Todo', 0, 11)

hl('@variable', 7)
hl('@variable.builtin', 14)
hl('@variable.parameter', 7)
hl('@variable.member', 7)
hl('@property', 7)
hl('@constant.builtin', 13)
hl('@constant.macro', 12)
hl('@module', 14)
hl('@module.builtin', 14)
hl('@label', 3)
hl('@string.documentation', 6)
hl('@type.builtin', 10)
hl('@type.qualifier', 2)
hl('@attribute', 12)
hl('@attribute.builtin', 12)
hl('@function', 15)
hl('@function.builtin', 14)
hl('@function.macro', 12)
hl('@constructor', 10)
link('@constructor.lua', '@punctuation.bracket')
hl('@keyword', 11)
hl('@keyword.modifier', 2)
hl('@keyword.storage', 2)
hl('@keyword.type', 10)
hl('@keyword.import', 12)
hl('@keyword.directive', 12)
hl('@keyword.directive.define', 12)
hl('@keyword.debug', 9)
hl('@comment.todo', 0, 11)
hl('@comment.note', 0, 6)
hl('@comment.warning', 0, 11)
hl('@comment.error', 15, 1)
hl('@markup.heading', 11)
hl('@markup.strong', 15, nil, { bold = true })
hl('@markup.italic', nil, nil, { italic = true })
hl('@markup.underline', nil, nil, ul)
hl('@markup.strikethrough', nil, nil, { strikethrough = true })
hl('@markup.raw', 10)
hl('@markup.link', 12)
hl('@markup.link.url', 12, nil, ul)
hl('@markup.link.label', 14)
hl('@markup.list', 9)
hl('@markup.quote', 6)
hl('@markup.math', 13)
hl('@tag', 11)
hl('@tag.builtin', 11)
hl('@tag.attribute', 10)
hl('@tag.delimiter', 7)

set(0, '@lsp.type.keyword', {})
link('@lsp.type.const', '@constant')
link('@lsp.type.formatSpecifier', '@string.escape')
link('@lsp.typemod.function.defaultLibrary', '@function.builtin')
hl('@lsp.type.comment.c', 8)
hl('@lsp.type.comment.cpp', 8)

hl('LspReferenceText', nil, 4)
hl('LspReferenceRead', nil, 4)
hl('LspReferenceWrite', nil, 4, ul)
hl('LspInlayHint', 8)
hl('LspCodeLens', 8)
hl('LspCodeLensSeparator', 8)
hl('LspSignatureActiveParameter', 11, nil, ul)

hl('DiagnosticError', 9)
hl('DiagnosticWarn', 11)
hl('DiagnosticInfo', 14)
hl('DiagnosticHint', 6)
hl('DiagnosticOk', 10)
hl('DiagnosticUnderlineError', nil, nil, curl, 9)
hl('DiagnosticUnderlineWarn', nil, nil, curl, 11)
hl('DiagnosticUnderlineInfo', nil, nil, curl, 14)
hl('DiagnosticUnderlineHint', nil, nil, curl, 6)
hl('DiagnosticUnderlineOk', nil, nil, curl, 10)
hl('DiagnosticDeprecated', nil, nil, { strikethrough = true }, 9)
hl('DiagnosticUnnecessary', 8)

hl('MiniStatuslineModeNormal', 15, 4)
hl('MiniStatuslineModeInsert', 0, 2)
hl('MiniStatuslineModeVisual', 15, 5)
hl('MiniStatuslineModeReplace', 15, 1)
hl('MiniStatuslineModeCommand', 15, 3)
hl('MiniStatuslineModeOther', 0, 6)
hl('MiniStatuslineDevinfo', 15, 8)
hl('MiniStatuslineFileinfo', 15, 8)
link('MiniStatuslineFilename', 'StatusLine')
link('MiniStatuslineInactive', 'StatusLineNC')
hl('GitSignsDiffStaged', 8)
for ty, col in pairs { Add = 2, Untracked = 2, Change = 3, Changedelete = 3, Delete = 1, Topdelete = 1 } do
	for _, kind in ipairs { '', 'Nr', 'Cul', 'Ln' } do
		hl('GitSignsStaged' .. ty .. kind, col)
	end
end
link('BlinkCmpLabelMatch', 'PmenuMatch')
link('TelescopeMatching', 'IncSearch')
link('TelescopePromptPrefix', 'Statement')
