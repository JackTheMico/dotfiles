require("starship"):setup()
require("full-border"):setup()

require("eza-preview"):setup({
	-- Determines the directory depth level to tree preview (default: 3)
	level = 3,

	-- Whether to follow symlinks when previewing directories (default: false)
	follow_symlinks = true,

	-- Whether to show target file info instead of symlink info (default: false)
	dereference = false,
})

-- Or use default settings with empty table
require("eza-preview"):setup({})

require("smart-enter"):setup({
	open_multi = true,
})

require("git"):setup()

require("relative-motions"):setup({ show_numbers = "relative", show_motion = true }) -- ~/.config/yazi/init.lua
