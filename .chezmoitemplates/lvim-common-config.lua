-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.patternreddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
vim.opt.relativenumber = true
-- Tamporary Settings for tcss
vim.filetype.add({
	extension = {
		tcss = "css",
	},
})

vim.opt.foldlevel = 99
vim.opt.conceallevel = 2

lvim.format_on_save = false
lvim.colorscheme = "desert"
lvim.transparent_window = true
lvim.builtin.treesitter.rainbow.enable = true

lvim.plugins = {
	{ "rebelot/kanagawa.nvim" },
	{
		"nvim-neorg/neorg",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/neorg/notes",
								firework = "~/neorg/firework",
								personal = "~/neorg/personal",
							},
						},
					},
					["core.completion"] = {},
					["core.integrations.telescope"] = {},
				},
			})
		end,
		build = ":Neorg sync-parsers",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
	},
	{ "voldikss/vim-translator" },
	{
		"wakatime/vim-wakatime",
	},
	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup()
		end,
	},
	{
		"folke/lsp-colors.nvim",
		event = "BufRead",
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	{ "Mofiqul/dracula.nvim" },
	{ "frenzyexists/aquarium-vim" },
	{
		"sontungexpt/witch",
		priority = 1000,
		lazy = false,
		config = function(_, opts)
			require("witch").setup(opts)
		end,
	},
	{ "xiyaowong/telescope-emoji.nvim" },
	{ "tsakirist/telescope-lazy.nvim" },
	{ "Textualize/tcss-vscode-extension" },
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app ;npm install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_auto_start = 1
		end,
	},
	{ "alker0/chezmoi.vim" },
	{
		"JackTheMico/nvim-nu",
		config = function()
			require("nu").setup({})
		end,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		lazy = true,
		config = function()
			require("persistence").setup({
				dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
				options = { "buffers", "curdir", "tabpages", "winsize" },
			})
		end,
	},
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		config = function()
			-- Change '<C-g>' here to any keycode you like.
			vim.keymap.set("i", "<C-o>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-j>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-k>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, silent = true })
		end,
	},
	{
		"AckslD/nvim-neoclip.lua",
		after = "telescope",
		config = function()
			require("neoclip").setup({})
		end,
	},
	{ "nvim-telescope/telescope-media-files.nvim" },
	{ "nvim-telescope/telescope-frecency.nvim" },
	{ "debugloop/telescope-undo.nvim" },
	{ "benfowler/telescope-luasnip.nvim" },
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				width = 120, -- Width of the floating window
				height = 25, -- Height of the floating window
				default_mappings = true, -- Bind default mappings
				debug = false, -- Print debug information
				opacity = 10, -- 0-100 opacity level of the floating window where 100 is fully transparent.
				post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
				-- You can use "default_mappings = true" setup option
				-- Or explicitly set keybindings
				-- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
				-- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
				-- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").on_attach()
		end,
	},
	{ "tpope/vim-repeat" },
	{
		"tpope/vim-surround",

		-- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
		-- setup = function()
		--  vim.o.timeoutlen = 500
		-- end
	},
	{
		"itchyny/vim-cursorword",
		event = { "BufEnter", "BufNewFile" },
		config = function()
			vim.api.nvim_command("augroup user_plugin_cursorword")
			vim.api.nvim_command("autocmd!")
			vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
			vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
			vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
			vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
			vim.api.nvim_command("augroup END")
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
	},
	{
		"f-person/git-blame.nvim",
		event = "BufRead",
		config = function()
			vim.cmd("highlight default link gitblame SpecialComment")
			require("gitblame").setup({ enabled = false })
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						"class",
						"function",
						"method",
					},
				},
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufRead",
	},
	{
		"mrjones2014/nvim-ts-rainbow",
	},
	{
		"tzachar/cmp-tabnine",
		build = "./install.sh",
		dependencies = "hrsh7th/nvim-cmp",
		event = "InsertEnter",
	},
	{
		"ggandor/leap.nvim",
		name = "leap",
		config = function()
			require("leap").create_default_mappings()
		end,
	},
	{ "mfussenegger/nvim-dap-python" },
	{ "nvim-neotest/neotest" },
	{ "nvim-neotest/neotest-python" },
}

-- Neorg
require("nvim-treesitter.configs").setup({
	ensure_installed = { "norg" },
	highlight = {
		enable = true,
	},
})

-- Setup dap-python
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
-- Setup Telescope extensions
lvim.builtin.telescope.on_config_done = function(telescope)
	pcall(telescope.load_extension, "frecency")
	pcall(telescope.load_extension, "neoclip")
	pcall(telescope.load_extension, "media_files")
	pcall(telescope.load_extension, "undo")
	pcall(telescope.load_extension, "luasnip")
	pcall(telescope.load_extension, "emoji")
	pcall(telescope.load_extension, "lazy")
	-- any other extensions loading
end
pcall(function()
	require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)
local dapython = require("dap-python")
dapython.test_runner = "pytest"
dapython.setup(mason_path .. "packages/debugpy/venv/bin/python")

require("neotest").setup({
	adapters = {
		require("neotest-python")({
			dap = {
				justMyCode = false,
				console = "integratedTerminal",
			},
			args = { "--log-level", "DEBUG", "--quiet" },
			runner = "pytest",
		}),
	},
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "codespell", filetypes = { "lua", "python" } },
})

-- Key Mappings
-- Neorg
local neorg_callbacks = require("neorg.core.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
	-- Map all the below keybinds only when the "norg" mode is active
	keybinds.map_event_to_mode("norg", {
		n = { -- Bind keys in normal mode
			{ "<C-s>", "core.integrations.telescope.find_linkable" },
		},

		i = { -- Bind in insert mode
			{ "<C-l>", "core.integrations.telescope.insert_link" },
		},
	}, {
		silent = true,
		noremap = true,
	})
end)

lvim.builtin.which_key.mappings["<space>"] = {
	name = "Term",
	f = { "<cmd>ToggleTerm<cr>", "FloatTerm" },
	h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal Term" },
	v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical Term" },
	t = { "<cmd>ToggleTerm direction=tab<cr>", "Tab Term" },
}
lvim.builtin.which_key.mappings["bt"] = {
	"<cmd>Telescope buffers<cr>",
	"Buffers",
}
lvim.builtin.which_key.mappings["t"] = {
	name = "Telescope",
	t = { "<cmd>TranslateW<cr>", "Translate" },
	r = { "<cmd>TranslateR<cr>", "Replace with the translation" },
	b = { "<cmd>Telescope buffers<cr>", "Buffers" },
	h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
	c = { "<cmd>Telescope neoclip<cr>", "Neoclip" },
	s = { "<cmd>Telescope luasnip<cr>", "Snippets" },
	l = { "<cmd>Telescope lazy<cr>", "Lazy" },
	u = { "<cmd>Telescope undo<cr>", "Undo" },
	e = { "<cmd>Telescope emoji<cr>", "Emoji" },
	f = { "<cmd>Telescope frecency<cr>", "Emoji" },
}
lvim.builtin.which_key.mappings["S"] = {
	name = "Session",
	c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
	l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
	q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
lvim.keys.normal_mode["<S-h>"] = "<cmd>BufferLineCyclePrev<cr>"
lvim.keys.normal_mode["<S-l>"] = "<cmd>BufferLineCycleNext<cr>"
lvim.keys.insert_mode["jk"] = "<Esc>"
lvim.builtin.which_key.mappings["w"] = {
	name = "Window",
	w = { "<cmd>w<cr>", "Save" },
	v = { "<cmd>vsplit<cr>", "Vertical" },
	h = { "<cmd>split<cr>", "Horizontal" },
	s = { "<cmd>SymbolsOutline<cr>", "SymbolsOutline" },
	d = { "<cmd>q<cr>", "Close" },
}

-- Neotest
lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>", "Test Method" }
lvim.builtin.which_key.mappings["dM"] =
	{ "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = {
	"<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>",
	"Test Class",
}
lvim.builtin.which_key.mappings["dF"] = {
	"<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
	"Test Class DAP",
}
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }

-- Auto Commands
lvim.autocommands = {
	{
		"BufEnter",
		{
			pattern = { "*.tmpl", "*.py", "*.toml", "*.css", "*.tcss", "*.lua" },
			command = "setlocal shiftwidth=4 tabstop=4 softtabstop=4",
		},
	},
}
