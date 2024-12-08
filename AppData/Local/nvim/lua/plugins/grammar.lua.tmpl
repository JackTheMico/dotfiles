return {
	-- Improved ltex integration, supporting code actions
	{ "barreiroleo/ltex-extra.nvim" },

	-- add various LSP to lspconfig
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- suppress virtual text
			diagnostics = {
				virtual_text = false,
			},
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			servers = {
				-- use LanguageTool via ltex for spell checking
				ltex = {
					filetypes = {
						"bib",
						"gitcommit",
						"latex",
						"mail",
						"markdown",
						"norg",
						"org",
						"pandoc",
						"rst",
						"text",
					},
					settings = {
						-- https://valentjn.github.io/ltex/settings.html
						ltex = {
							language = "en-US",
							additionalRules = {
								enablePickyRules = true,
								motherTongue = "fr",
								languageModel = "/usr/share/ngrams/",
							},
							-- https://community.languagetool.org/rule/list?lang=en
							disabledRules = {
								["en-US"] = { "TOO_LONG_SENTENCE", "OXFORD_SPELLING_Z_NOT_S", "DASH_RULE" },
								fr = {
									"APOS_TYP",
									"FRENCH_WHITESPACE",
									"FR_SPELLING_RULE",
									"COMMA_PARENTHESIS_WHITESPACE",
								},
							},
						},
					},
				},
			},
			setup = {
				-- integrate ltex_extra with lazyvim
				-- https://github.com/LazyVim/LazyVim/discussions/403
				ltex = function(_, opts)
					vim.api.nvim_create_autocmd("LspAttach", {
						callback = function(args)
							local client = vim.lsp.get_client_by_id(args.data.client_id)
							if client.name == "ltex" then
								require("ltex_extra").setup({
									load_langs = { "en-US", "fr" }, -- languages for witch dictionaries will be loaded
									init_check = true, -- whether to load dictionaries on startup
									path = vim.fn.stdpath("config") .. "/spell", -- path to store dictionaries.
									log_level = "none", -- "none", "trace", "debug", "info", "warn", "error", "fatal"
								})
							end
						end,
					})
				end,
			},
		},
	},
}
