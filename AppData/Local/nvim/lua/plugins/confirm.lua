return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			yaml = { "yamlfmt" },
			python = { "isort", "ruff_format" },
			markdown = { "markdownlint-cli2" },
			json = { "biome" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
