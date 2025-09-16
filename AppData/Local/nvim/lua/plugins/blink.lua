return {
  "saghen/blink.cmp",
  optional = true,
  dependencies = { "allaman/emoji.nvim", "saghen/blink.compat", "rafamadriz/friendly-snippets" },
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = "default" },
    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    -- (Default) Only show the documentation popup when manually triggered
    -- completion = { documentation = { auto_show = false } },
    completion = { documentation = { auto_show = true } },
    sources = {
      default = { "emoji", "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        codecompanion = { "codecompanion" },
      },
      providers = {
        emoji = {
          name = "emoji",
          module = "blink.compat.source",
          -- overwrite kind of suggestion
          transform_items = function(ctx, items)
            local kind = require("blink.cmp.types").CompletionItemKind.Text
            for i = 1, #items do
              items[i].kind = kind
            end
            return items
          end,
        },
      },
    },
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
    opts_extend = { "sources.default" },
  },
}
