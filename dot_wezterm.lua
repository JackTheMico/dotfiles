-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28
config.default_prog = { "nu.exe" }
config.font = wezterm.font_with_fallback({
	"Maple Mono NF CN",
	"JetBrains Mono", -- 推荐：免费且支持连字
})

config.font_size = 13.0
-- or, changing the font size and color scheme.
config.color_scheme = "Catppuccin Mocha"
-- 其他选项： "Dracula", "One Dark (base16)", "Solarized Dark"
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" } -- 启用连字
config.window_background_opacity = 0.75
config.window_padding = { left = 5, right = 5, top = 5, bottom = 2 } -- 内边距
config.hide_tab_bar_if_only_one_tab = true -- 单标签页时隐藏标签栏
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25

-- Performance
config.max_fps = 60 -- 限制刷新率
config.front_end = "WebGpu" -- 使用GPU加速 (需要支持WebGPU的显卡)
config.enable_wayland = false -- Windows无需Wayland

-- Finally, return the configuration to wezterm:
return config
