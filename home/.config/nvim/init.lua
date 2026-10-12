vim.loader.enable()

require 'options'
require 'tabs'

require 'keymaps'

do

	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then
			local stderr = result.stderr or ''
			local stdout = result.stdout or ''
			local output = stderr ~= '' and stderr or stdout
			if output == '' then output = 'No output from build command.' end
			vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
		end
	end

	vim.api.nvim_create_autocmd('PackChanged', {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= 'install' and kind ~= 'update' then return end

			if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
				run_build(name, { 'make' }, ev.data.path)
				return
			end

			if name == 'LuaSnip' then
				if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
				return
			end

			if name == 'nvim-treesitter' then
				if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
				vim.cmd 'TSUpdate'
				return
			end
		end,
	})
end

local function gh(repo) return 'https://github.com/' .. repo end

do
	vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
	local gitsigns = require 'gitsigns'
	gitsigns.setup {
		signs = {
			add = { text = '+' },
			change = { text = '~' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '~' },
		},
		on_attach = function(bufnr)
			vim.keymap.set('n', ']c', function()
				if vim.wo.diff then
					vim.cmd.normal { ']c', bang = true }
				else
					gitsigns.nav_hunk 'next'
				end
			end, { desc = 'Jump to next git [c]hange', buf = bufnr })

			vim.keymap.set('n', '[c', function()
				if vim.wo.diff then
					vim.cmd.normal { '[c', bang = true }
				else
					gitsigns.nav_hunk 'prev'
				end
			end, { desc = 'Jump to previous git [c]hange', buf = bufnr })

			vim.keymap.set(
				'v',
				'<leader>hs',
				function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
				{ desc = 'git [s]tage hunk', buf = bufnr }
			)
			vim.keymap.set(
				'v',
				'<leader>hr',
				function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
				{ desc = 'git [r]eset hunk', buf = bufnr }
			)
			vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk', buf = bufnr })
			vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk', buf = bufnr })
			vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer', buf = bufnr })
			vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer', buf = bufnr })
			vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk', buf = bufnr })
			vim.keymap.set('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline', buf = bufnr })
			vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line', buf = bufnr })
			vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index', buf = bufnr })
			vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis '~' end, { desc = 'git [D]iff against last commit', buf = bufnr })
			vim.keymap.set('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunk [Q]uickfix list (all files in repo)', buf = bufnr })
			vim.keymap.set('n', '<leader>hq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (all changes in this file)', buf = bufnr })
			vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line', buf = bufnr })
			vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff', buf = bufnr })
			vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'text object [i]nside [h]unk', buf = bufnr })
		end,
	}

	vim.pack.add { gh 'folke/which-key.nvim' }
	local which_key_help = false
	require('which-key').setup {
		delay = function(ctx) return (which_key_help or ctx.plugin == 'spelling') and 0 or 0x7fffffff end,
		icons = { mappings = vim.g.have_nerd_font },
		spec = {
			{ '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
			{ '<leader>t', group = '[T]oggle' },
			{ '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
			{ 'gr', group = 'LSP Actions', mode = { 'n' } },
		},
	}
	vim.api.nvim_create_user_command('EnableHelp', function() which_key_help = true end, { desc = 'Show which-key popups' })
	vim.api.nvim_create_user_command('DisableHelp', function() which_key_help = false end, { desc = 'Hide which-key popups' })

	vim.cmd.colorscheme 'vscode'

	vim.pack.add { gh 'nvim-mini/mini.nvim' }

	if vim.g.have_nerd_font then
		require('mini.icons').setup()
		MiniIcons.mock_nvim_web_devicons()
	end

	require('mini.ai').setup {
		mappings = {
			around_next = 'aa',
			inside_next = 'ii',
		},
		n_lines = 500,
	}

	require('mini.surround').setup()

	local statusline = require 'mini.statusline'
	statusline.setup { use_icons = vim.g.have_nerd_font }

	statusline.section_location = function() return '%2l:%-2v' end

end

do

	local telescope_plugins = {
		gh 'nvim-lua/plenary.nvim',
		gh 'nvim-telescope/telescope.nvim',
		gh 'nvim-telescope/telescope-ui-select.nvim',
	}
	if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

	vim.pack.add(telescope_plugins)

	require('telescope').setup {
		extensions = {
			['ui-select'] = { require('telescope.themes').get_dropdown() },
		},
	}

	pcall(require('telescope').load_extension, 'fzf')
	pcall(require('telescope').load_extension, 'ui-select')

	local builtin = require 'telescope.builtin'
	vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
	vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
	vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
	vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
	vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
	vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
	vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
	vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
	vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
	vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
		callback = function(event)
			local buf = event.buf

			vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

			vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

			vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

			vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

			vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

			vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
		end,
	})

	vim.keymap.set('n', '<leader>/', function()
		builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
			winblend = 10,
			previewer = false,
		})
	end, { desc = '[/] Fuzzily search in current buffer' })

	vim.keymap.set(
		'n',
		'<leader>s/',
		function()
			builtin.live_grep {
				grep_open_files = true,
				prompt_title = 'Live Grep in Open Files',
			}
		end,
		{ desc = '[S]earch [/] in Open Files' }
	)

	vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
end

do

	vim.pack.add { gh 'j-hui/fidget.nvim' }
	require('fidget').setup {}

	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or 'n'
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
			end

			map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

			map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

			map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client:supports_method('textDocument/documentHighlight', event.buf) then
				local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
				vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd('LspDetach', {
					group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
					end,
				})
			end

			if client and client:supports_method('textDocument/inlayHint', event.buf) then
				map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
			end
		end,
	})

	local servers = {
		basedpyright = {
			settings = {
				basedpyright = {
					disableOrganizeImports = true,
					analysis = { typeCheckingMode = 'standard' },
				},
			},
		},
		ruff = {
			on_attach = function(client) client.server_capabilities.hoverProvider = false end,
		},
		bashls = {},
		awk_ls = {},
		gopls = {},
		ts_ls = {},
		html = {},
		cssls = {},
		jsonls = {},
		yamlls = {},
		taplo = {},
		marksman = {},
		neocmake = {},

		stylua = {},

		lua_ls = {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false

				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
				end

				local current_settings = client.config.settings
				client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
					runtime = {
						version = 'LuaJIT',
						path = { 'lua/?.lua', 'lua/?/init.lua' },
					},
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file('', true),
					},
				})
			end,
			settings = {
				Lua = {
					format = { enable = false },
				},
			},
		},
	}

	local system_servers = {
		clangd = {
			cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=never', '--pch-storage=memory' },
		},
		rust_analyzer = {
			settings = {
				['rust-analyzer'] = { check = { command = 'clippy' } },
			},
		},
	}

	vim.pack.add {
		gh 'neovim/nvim-lspconfig',
		gh 'mason-org/mason.nvim',
		gh 'mason-org/mason-lspconfig.nvim',
		gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
	}

	require('mason').setup {}

	require('mason-lspconfig').setup {
		automatic_enable = false,
	}

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		'shellcheck',
		'shfmt',
	})

	require('mason-tool-installer').setup { ensure_installed = ensure_installed }

	for _, set in ipairs { servers, system_servers } do
		for name, server in pairs(set) do
			vim.lsp.config(name, server)
			vim.lsp.enable(name)
		end
	end
end

do
	vim.pack.add { gh 'stevearc/conform.nvim' }
	require('conform').setup {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local enabled_filetypes = {
			}
			if enabled_filetypes[vim.bo[bufnr].filetype] then
				return { timeout_ms = 500 }
			else
				return nil
			end
		end,
		default_format_opts = {
			lsp_format = 'fallback',
		},
		formatters_by_ft = {
			sh = { 'shfmt' },
			bash = { 'shfmt' },
		},
	}

	vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end

do

	vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
	local ls = require 'luasnip'
	ls.setup { enable_autosnippets = true }

	local function me()
		local function git(key) return vim.trim(vim.fn.system { 'git', 'config', '--get', key }) end
		return ('%s <%s>'):format(git 'user.name', git 'user.email')
	end
	ls.add_snippets('all', {
		ls.snippet({ trig = 'me::', snippetType = 'autosnippet' }, {
			ls.dynamic_node(1, function()
				local open, lead, close = '/*', ' *', ' */'
				local pre, post = vim.bo.commentstring:match '^%s*(.-)%s*%%s%s*(.-)%s*$'
				if pre and pre ~= '' and not pre:find '^/[/*]' then
					if post == '' then
						open, lead, close = nil, pre, nil
					else
						open, lead, close = pre, '', post
					end
				end

				local pad = lead == '' and '' or lead .. ' '
				local function comment(body)
					local out = { '' }
					for _, s in ipairs(body) do
						out[#out + 1] = s == '' and lead or pad .. s
					end
					return out
				end

				local who = me()
				local now = os.time()
				local t = os.date('*t', now)
				local mid = comment { '', '# Created', 'Author: ' .. who, ('Date: %s %d, %d'):format(os.date('%B', now), t.day, t.year), 'License: ' }
				local tail = comment { '', '# Contributors', '- ' .. who }
				tail[#tail + 1] = close

				return ls.snippet_node(nil, {
					ls.text_node(open and { open, pad } or pad),
					ls.insert_node(1),
					ls.text_node(mid),
					ls.insert_node(2, 'GPL-3.0-only'),
					ls.text_node(tail),
				})
			end),
		}),
	})

	vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
	require('blink.cmp').setup {
		keymap = {
			preset = 'super-tab',

		},

		appearance = {
			nerd_font_variant = 'mono',
		},

		completion = {
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},

		sources = {
			default = { 'lsp', 'path', 'snippets' },
		},

		snippets = { preset = 'luasnip' },

		fuzzy = { implementation = 'lua' },

		signature = { enabled = true },
	}
end

do

	vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

	local parsers = {
		'bash',
		'c',
		'cpp',
		'rust',
		'python',
		'awk',
		'make',
		'kconfig',
		'devicetree',
		'printf',
		'regex',
		'diff',
		'html',
		'lua',
		'luadoc',
		'markdown',
		'markdown_inline',
		'query',
		'vim',
		'vimdoc',
	}
	require('nvim-treesitter').install(parsers)

	vim.pack.add { gh 'gentoo/gentoo-syntax' }

	local function treesitter_try_attach(buf, language)
		if not vim.treesitter.language.add(language) then
			vim.treesitter.stop(buf)
			return
		end

		if not vim.api.nvim_buf_is_valid(buf) then return end

		vim.treesitter.start(buf, language)

		local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

		if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
	end

	local available_parsers = require('nvim-treesitter').get_available()
	vim.api.nvim_create_autocmd('FileType', {
		callback = function(args)
			local buf, filetype = args.buf, args.match

			local language = vim.treesitter.language.get_lang(filetype)
			if not language then return end

			local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

			if vim.tbl_contains(installed_parsers, language) then
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available_parsers, language) then
				require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
			else
				treesitter_try_attach(buf, language)
			end
		end,
	})
end

do

	require 'kickstart.plugins.neo-tree'

end
