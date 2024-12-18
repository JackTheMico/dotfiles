return {
	"voldikss/vim-translator",
	opts = {
		translator_default_engines = { "google", "haici", "youdao" },
		translator_proxy_url = "http://127.0.0.1:7897",
		translator_history_enable = true,
	},
	keys = {
		{ "<leader>ta", "<cmd>TranslateW<cr>", desc = "Translate Word" },
		{ "<leader>tb", "<cmd>TranslateR<cr>", desc = "Replace translated Word" },
	},
	config = function(_, opts) end,
}
