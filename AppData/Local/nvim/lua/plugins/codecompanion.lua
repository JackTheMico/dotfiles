return {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ravitemer/mcphub.nvim",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        siliconflow = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              api_key = "sk-gpzivpakmarjkxafxngkuofnskkyxwphcjjazxghwndgozmk",
              url = "https://api.siliconflow.cn",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "deepseek-ai/DeepSeek-V3",
              },
            },
          })
        end,
        -- deepseek = function()
        --   return require("codecompanion.adapters").extend("deepseek", {
        --     env = {
        --       url = "https://api.deepseek.com/v1",
        --       api_key = "sk-ef4ddd93f78f47388b2e39e38817615d",
        --     },
        --   })
        -- end,
      },
      strategies = {
        chat = {
          adapter = "siliconflow",
        },
        inline = {
          adapter = "siliconflow",
        },
        -- cmd = {
        --   adapter = "deepseek",
        -- },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    })
  end,
}
