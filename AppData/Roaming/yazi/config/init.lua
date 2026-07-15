require("full-border"):setup()

require("starship"):setup()

require("easyjump"):setup()

require("augment-command"):setup({
    smooth_scrolling = true,
})

local bookmarks = {
  { tag = "Desktop",   path = "~/Desktop",   key = "d" },
  { tag = "Documents", path = "~/Documents", key = "D" },
  { tag = "Downloads", path = "~/Downloads", key = "o" },
}
require("whoosh"):setup {
  bookmarks = bookmarks,
  jump_notify = false,
}
