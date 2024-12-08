return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			yaml = { "yamlfmt" },
			python = { "isort", "ruff_format" },
			markdown = { "markdownlint-cli2" },
			json = { "biome" },
			astro = { "prettier", "biome" },
			javascript = { "prettier", "biome" },
			typescript = { "prettier", "biome" },
		},
	},
}
