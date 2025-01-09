return {
	"xzbdmw/colorful-menu.nvim",
	config = function()
		require("blink.cmp").setup({
			completion = {
				menu = {
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- conbined together in label by colorful-menu.nvim.
						--
						-- However, for `basedpyright`, it is recommend to set
						-- columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
						-- because the `label_description` will only be import path.
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
			},
		})
	end,
}
