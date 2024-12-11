return {
	"epwalsh/obsidian.nvim",
	version = "v3.9.0", -- recommended, use latest release instead of latest commit
	lazy = true,
	-- ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		-- refer to `:h file-pattern` for more examples
		"BufReadPre /mnt/d/Nutstore/Obsidian-Vaults/Family/*.md",
		"BufNewFile /mnt/d/Nutstore/Obsidian-Vaults/Family/*.md",
	},
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "Family",
				path = "/mnt/d/Nutstore/Obsidian-Vaults/Family",
			},
			-- {
			-- 	name = "work",
			-- 	path = "~/vaults/work",
			-- },
		},
	},
}
