return {
	{
		"JackTheMico/obsidian.nvim",
		version = "v3.9.0", -- recommended, use latest release instead of latest commit
		lazy = true,
		completion = {
			nvim_cmp = false,
		},
		-- ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
			-- refer to `:h file-pattern` for more examples
			"BufReadPre /mnt/d/nutstore/Obsidian-Vaults/文漾/*.md",
			"BufNewFile /mnt/d/nutstore/Obsidian-Vaults/文漾/*.md",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "wenyoung",
					path = "/mnt/d/nutstore/Obsidian-Vaults/文漾",
				},
			},
			-- Optional, for templates (see below).
			templates = {
				folder = "/mnt/d/nutstore/Obsidian-Vaults/文漾/templates",
				date_format = "%d-%m-%Y",
				time_format = "%H:%M",
				-- A map for custom variables, the key should be the variable and the value a function
				substitutions = {},
			},
			-- Optional, set to true if you use the Obsidian Advanced URI plugin.
			-- https://github.com/Vinzent03/obsidian-advanced-uri
			use_advanced_uri = false,
			-- Optional, customize how note IDs are generated given an optional title.
			---@param title string|?
			---@return string
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
			end,
			-- Optional, determines how certain commands open notes. The valid options are:
			-- 1. "current" (the default) - to always open in the current window
			-- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
			-- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
			open_notes_in = "vsplit",
		},
		config = function(_, opts)
			require("obsidian").setup(opts)

			-- HACK: fix error, disable completion.nvim_cmp option, manually register sources
			local cmp = require("cmp")
			cmp.register_source("obsidian", require("cmp_obsidian").new())
			cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
			cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = { "saghen/blink.compat" },
		opts = {
			sources = {
				default = { "obsidian", "obsidian_new", "obsidian_tags" },
				providers = {
					obsidian = {
						name = "obsidian",
						module = "blink.compat.source",
					},
					obsidian_new = {
						name = "obsidian_new",
						module = "blink.compat.source",
					},
					obsidian_tags = {
						name = "obsidian_tags",
						module = "blink.compat.source",
					},
				},
			},
		},
	},
}
