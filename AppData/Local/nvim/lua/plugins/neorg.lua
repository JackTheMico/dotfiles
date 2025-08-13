return {
  "nvim-neorg/neorg",
  -- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  -- lazy-load on filetype
  ft = "norg",
  version = "*", -- Pin Neorg to the latest stable release
  config = true,
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
    },
  },
}
