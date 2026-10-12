vim.pack.add {
	{ src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

local function clicked_cursor_line()
	local m = vim.fn.getmousepos()
	return m.winid == vim.api.nvim_get_current_win() and m.line == vim.fn.line '.' and m.winrow == vim.fn.winline()
end

local function is_scratch(buf)
	return vim.api.nvim_buf_get_name(buf) == ''
		and vim.bo[buf].buftype == ''
		and not vim.bo[buf].modified
		and vim.api.nvim_buf_line_count(buf) == 1
		and vim.api.nvim_buf_get_lines(buf, 0, 1, true)[1] == ''
end

local function open_in_tab(state, path)
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype ~= 'neo-tree' and is_scratch(buf) then
			vim.api.nvim_set_current_win(win)
			vim.cmd.edit(vim.fn.fnameescape(path))
			return
		end
	end

	local root = state.path
	local tabs = vim.fn.tabpagenr '$'
	vim.cmd('tab drop ' .. vim.fn.fnameescape(path))
	if vim.fn.tabpagenr '$' > tabs then require('neo-tree.command').execute { action = 'show', dir = root, reveal_file = path } end
end

local function click(state)
	if not clicked_cursor_line() then return end
	local node = state.tree:get_node()
	if node.type == 'directory' and node:get_id() ~= state.path then state.commands.toggle_node(state) end
end

local function double_click(state)
	if not clicked_cursor_line() then return end
	local node = state.tree:get_node()
	if node.type == 'directory' then
		state.commands[node:get_id() == state.path and 'navigate_up' or 'set_root'](state)
	elseif node.type == 'file' then
		open_in_tab(state, node:get_id())
	end
end

require('neo-tree').setup {
	close_if_last_window = true,
	window = {
		position = 'left',
	},
	filesystem = {
		window = {
			mappings = {
				['\\'] = 'close_window',
				['<LeftRelease>'] = { click, desc = 'toggle directory' },
				['<2-LeftMouse>'] = { function() end, desc = 'nop' },
				['<2-LeftRelease>'] = { double_click, desc = 'enter directory / open file in tab' },
			},
		},
	},
}

local neo_tree_startup = vim.api.nvim_create_augroup('neo-tree-startup', { clear = true })

vim.api.nvim_create_autocmd('StdinReadPre', {
	group = neo_tree_startup,
	callback = function() vim.g.neo_tree_from_stdin = true end,
})

vim.api.nvim_create_autocmd('VimEnter', {
	group = neo_tree_startup,
	callback = function()
		if vim.fn.argc() > 0 or vim.g.neo_tree_from_stdin then return end
		vim.cmd 'Neotree show'
	end,
})
