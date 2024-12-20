return {

	{
		"neovim/nvim-lspconfig",
		opts = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			-- change a keymap
			-- disable a keymap
			keys[#keys + 1] = { "gd", false }
			keys[#keys + 1] = { "gD", false }
			keys[#keys + 1] = { "gY", false }
			keys[#keys + 1] = { "gM", false }
			-- add a keymap
			-- keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
		end,
	},

	{
		"dnlhc/glance.nvim",
		-- LSP keymaps
		opts = function()
			local glance = require("glance")
			glance.setup()
			-- Lua
			vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
			vim.keymap.set("n", "gR", "<CMD>Glance references<CR>")
			vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
			vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>")
		end,
	},
	-- LSP keymaps
}
