return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
  ft = { "markdown", "codecompanion" },
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  config = function()
    require("render-markdown").setup({
      -- render_modes = true,
      heading = { border = true },
      code = {
        width = "block",
        left_margin = 0.5,
        left_pad = 0.2,
        right_pad = 0.2,
      },
      checkbox = {
        custom = {
          important = {
            raw = "[~]",
            rendered = "󰓎 ",
            highlight = "DiagnosticWarn",
          },
        },
      },
      indent = { enabled = true },
      pipe_table = { preset = "heavy" },
    })
  end,
}
