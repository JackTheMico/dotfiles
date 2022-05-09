--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- vim
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.guifont = "hack:h15" -- the font used in graphical neovim applications
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.tabstop = 4
vim.opt.mouse = "a"
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.shell = "/usr/bin/zsh"
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_transparency = 1.0
vim.g.neovide_fullscreen = false
vim.g.neovide_input_use_logo = true
-- lua project.nvim
vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.translator_default_engines = { "youdao", "bing", "haici" }
vim.g.translator_history_enable = true
vim.g.himalaya_mailbox_picker = 'telescope'
vim.g.himalaya_telescope_preview_enabled = 0
vim.o.runtimepath = vim.o.runtimepath .. ',~/.local/share/lunarvim/site/pack/packer/start/himalaya/vim'

require("nvim-tree").setup({
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true
  },
})

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "tokyonight"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
lvim.keys.normal_mode["<C-q>"] = "<cmd>BufferKill<cr>"
lvim.keys.normal_mode["<C-s>"] = ":lua require('rest-nvim').run()<cr>"
lvim.keys.normal_mode["<M-o>"] = "<cmd>RnvimrToggle<cr>"
lvim.keys.normal_mode["<M-i>"] = "<cmd>RnvimrToggle<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
  v = { "<cmd>ToggleTerm size=40 direction=vertical<cr>", "Term vertical" },
  t = { "<cmd>ToggleTerm direction=float<cr>", "Term float" },
  s = { "<cmd>TranslateW<cr>", "Translate" },
  x = { "<cmd>TranslateH<cr>", "Export Translate History" },
  S = { "<cmd>SymbolsOutline<cr>", "SymbolsOutline" },
}

lvim.builtin.which_key.mappings["S"] = {
  name = "+Spectre",
  o = { ":lua require('spectre').open()<cr>", "Open" },
  w = { ":lua require('spectre').open_visual({select_word=true})<cr>", "Spectre Word" },
  s = { ":lua require('spectre').open_visual()<cr>", "Visual" },
  f = { ":lua require('spectre').open_file_search()<cr>", "File" },
  d = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle Dapui" },
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
lvim.builtin.which_key.mappings["c"] = {
  name = "+Cmus",
  x = { "<cmd>CmusPlay<cr>", "Play" },
  s = { "<cmd>CmusPause<cr>", "Pause" },
  S = { "<cmd>CmusStop<cr>", "Stop" },
  n = { "<cmd>CmusNext<cr>", "Next" },
  p = { "<cmd>CmusPrevious<cr>", "Previous" },
  i = { "<cmd>CmusCurrent<cr>", "Current" },
}
lvim.builtin.which_key.mappings["O"] = {
  name = "Octo+",
  a = { "<cmd>Octo actions<cr>", "Octo Actions" },
  r = {
    name = "+Review",
    s = { "<cmd>Octo review start<cr>", "Review Start" },
    S = { "<cmd>Octo review submit<cr>", "Review Submit" },
  },
  p = {
    name = "+Pull Request",
    c = { "<cmd>Octo pr create<cr>", "Create PR" },
    r = { "<cmd>Octo pr reload<cr>", "Reload PR" },
    d = { "<cmd>Octo pr diff<cr>", "PR Diff" },
    l = { "<cmd>Octo pr list<cr>", "PR List" },
    m = { "<cmd>Octo pr merge<cr>", "PR Merge" }
  }
}


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.terminal.active = true
lvim.builtin.terminal.persist_size = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1
lvim.builtin.lualine.active = true
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.gitsigns.opts.linehl = true
lvim.builtin.gitsigns.opts.numhl = true
lvim.builtin.project.active = true
lvim.builtin.project.silent_chdir = false
lvim.builtin.project.manual_mode = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
lvim.lsp.automatic_servers_installation = true

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- TODO: custom pyright for virtualenv
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {
-- settings = {
--   python = {
--     venvPath = "/home/dlwxxxdlw/.pyenv/versions",
--     venv = "data_tracking-RLKEryHj",
--     pythonPath = "python"
--   }
-- }
-- } -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup.root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules")
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black", filetypes = { "python" } },
-- { exe = "isort", filetypes = { "python" } },
-- {
--   exe = "prettier",
--   ---@usage arguments to pass to the formatter
--   -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--   args = { "--print-with", "100" },
--   ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--   filetypes = { "typescript", "typescriptreact" },
-- },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
-- { exe = "flake8", filetypes = { "python" } },
--   {
--     exe = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--severity", "warning" },
--   },
-- {
-- exe = "codespell",
---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
-- filetypes = { "python" },
-- },
-- }

-- Additional Plugins
lvim.plugins = {
  { "folke/tokyonight.nvim" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  { 'michaelb/sniprun', run = 'bash ./install.sh' },
  { "lambdalisue/vim-pyenv" },
  { "plytophogy/vim-virtualenv" },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "tpope/vim-surround",
    keys = { "c", "d", "y" },
    config = function()
      vim.cmd("nmap ds       <Plug>Dsurround")
      vim.cmd("nmap cs       <Plug>Csurround")
      vim.cmd("nmap cS       <Plug>CSurround")
      vim.cmd("nmap ys       <Plug>Ysurround")
      vim.cmd("nmap yS       <Plug>YSurround")
      vim.cmd("nmap yss      <Plug>Yssurround")
      vim.cmd("nmap ySs      <Plug>YSsurround")
      vim.cmd("nmap ySS      <Plug>YSsurround")
      vim.cmd("xmap gs       <Plug>VSurround")
      vim.cmd("xmap gS       <Plug>VgSurround")
    end
  },
  { "tpope/vim-repeat" },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead"
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      })
    end
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  {
    "Pocco81/AutoSave.nvim",
    config = function()
      require("autosave").setup()
    end,
  },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require "lsp_signature".setup()
    end
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
  },
  {
    "pwntester/octo.nvim",
    event = "BufRead",
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  { 'nvim-orgmode/orgmode' },
  {
    'lukas-reineke/headlines.nvim',
    config = function()
      require('headlines').setup()
    end,
  },
  {
    "akinsho/org-bullets.nvim", config = function()
      require("org-bullets").setup {
        symbols = { "◉", "○", "✸", "✿" },
        -- or a function that receives the defaults and returns a list
        -- symbols = function(default_list)
        --   table.insert(default_list, "♥")
        --   return default_list
        -- end
      }
    end },
  {
    "NTBBloodbath/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup {
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
      }
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
  },
  {
    "mg979/vim-visual-multi"
  },
  {
    "metakirby5/codi.vim",
    cmd = "Codi",
  },
  { "voldikss/vim-translator" },
  {
    "azadkuh/vim-cmus"
  },
  { "soywod/himalaya", rtp = 'vim' },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  { 'wakatime/vim-wakatime' },
  {
    "tzachar/cmp-tabnine",
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("cmp_tabnine").setup({
        max_lines = 1000;
        max_num_results = 20;
        sort = true;
        run_on_every_keystroke = true;
        snippet_placeholder = '..';
        ignored_file_types = { -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        };
        show_prediction_strength = false;
      })
    end
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
    end
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "p00f/nvim-ts-rainbow",
  },
  {
    'rktjmp/fwatch.nvim',
  },
  {
    'TravonteD/luajob',
  },
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
}

-- org setup
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- Load custom tree-sitter grammar for org filetype
local orgmode = require("orgmode")
orgmode.setup_ts_grammar()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'org',
}

require 'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    disable = { 'org' }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = { 'org' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = { 'org' }, -- Or run :TSUpdate org
}

table.insert(lvim.builtin.cmp.sources, { name = "orgmode" })
orgmode.setup({
  org_agenda_files = { '~/Nutstore Files/org/todo.org',
    '~/Nutstore Files/org/notes.org',
    '~/Nutstore Files/org/journal.org' },
  org_default_notes_file = '~/Nutstore Files/org/notes.org',
  org_todo_keywords = { 'TODO(T)', 'WAITING(w)', 'Started(s)', '|', 'DONE(d)', 'DELEGATED(D)', 'CANCELED(C)' },
  org_priority_default = 'B',
  org_agenda_templates = {
    t = { description = 'Task', template = '* TODO [#B] %?\n %U\n %a', target = '~/Nutstore Files/org/todo.org' },
    d = { description = 'Todo', template = '* TODO [#C] %?\n %U\n %F', target = '~/Nutstore Files/org/todo.org' },
    j = { description = 'Journal', template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?', target = '~/Nutstore Files/org/journal.org' },
    n = { description = 'Note', template = '* %?\n %U\n %F', target = '~/Nutstore Files/org/notes.org' },
  }
})

--luasnip

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local sn = ls.snippet_node
-- local fmt = require("luasnip.extras.fmt").fmt
local d = ls.dynamic_node
local date_input = function(args, snip, old_state, fmt)
	local fmt = fmt or "%Y-%m-%d"
	return sn(nil, i(1, os.date(fmt)))
end
ls.add_snippets("all", {
	s("time", {
		d(1, date_input, {}, { user_args = { "%A, %B %d of %Y" } }),
	}),
})
require("luasnip.loaders.from_vscode").lazy_load({ path = {"~/.config/lvim/snippets" } })

-- dapui
-- local dap, dapui = require("dap"), require("dapui")
-- dapui.setup()
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end

-- rainbow
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled     -- ...
  },
  -- ...
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    colors = {
      "#81A1C1",
      "#A3BE8C",
      "#B48EAD",
      "#F0D399",
      "#D9B263",
      "#A6ACB9",
    }, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}

-- himalaya
local email_num = 0
local function himalayacounter()
    local handle = io.popen("tail -n 1 /tmp/himalaya-counter")
    if handle then
      local result = handle:read("*a")
      return result
    end
end
local function himalaya_status()
  local res = ""
  email_num = himalayacounter()
  res = string.format('📫 %d', email_num)
  return res
end

local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_c = {
  himalaya_status
}

local fwatch = require('fwatch')
fwatch.watch("/tmp/himalaya-counter", {
  on_event = function()
    email_num = himalayacounter()
  end
})

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
  -- On entering insert mode in any file, scroll the window so the cursor line is centered
  { "InsertEnter", "*", ":normal zz" },
 }
