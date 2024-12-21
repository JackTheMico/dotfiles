-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

-- map("i", "<A-f>", function()
-- 	require("neocodeium").accept()
-- end)
-- map("i", "<A-w>", function()
-- 	require("neocodeium").accept_word()
-- end)
-- map("i", "<A-a>", function()
-- 	require("neocodeium").accept_line()
-- end)
-- map("i", "<A-e>", function()
-- 	require("neocodeium").cycle_or_complete()
-- end)
-- map("i", "<A-r>", function()
-- 	require("neocodeium").cycle_or_complete(-1)
-- end)
-- map("i", "<A-c>", function()
-- 	require("neocodeium").clear()
-- end)

map("i", "jk", "<esc>")
