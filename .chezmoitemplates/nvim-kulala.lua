return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>r", "", desc = "+Rest", ft = "http" },
		{ "<leader>rb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open scratchpad", ft = "http" },
		{ "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL", ft = "http" },
		{ "<leader>rC", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Paste from curl", ft = "http" },
		{
			"<leader>rg",
			"<cmd>lua require('kulala').download_graphql_schema()<cr>",
			desc = "Download GraphQL schema",
			ft = "http",
		},
		{ "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect current request", ft = "http" },
		{ "<leader>rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request", ft = "http" },
		{ "<leader>rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Jump to previous request", ft = "http" },
		{ "<leader>rq", "<cmd>lua require('kulala').close()<cr>", desc = "Close window", ft = "http" },
		{ "<leader>rr", "<cmd>lua require('kulala').replay()<cr>", desc = "Replay the last request", ft = "http" },
		{ "<leader>rs", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request", ft = "http" },
		{ "<leader>rx", "<cmd>lua require('kulala').show_stats()<cr>", desc = "Show stats", ft = "http" },
		{ "<leader>rS", "<cmd>lua require('kulala').search()<cr>", desc = "Search request", ft = "http" },
		{ "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body", ft = "http" },
		{ "<leader>re", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "Select environment", ft = "http" },
	},
	opts = {
		default_view = "headers_body",
		display_mode = "float",
	},
}
