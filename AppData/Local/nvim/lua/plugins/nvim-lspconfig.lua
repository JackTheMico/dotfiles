return {
  "neovim/nvim-lspconfig",
  opts = {
    -- make sure mason installs the server
    servers = {
      jsonls = {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
          json = {
            format = {
              enable = true,
            },
            schemas = {
              {
                url = "https://raw.githubusercontent.com/apify/apify-shared-js/refs/heads/master/packages/input_schema/src/schema.json",
                name = "Apify Actor Input Schema",
                fileMatch = { "**/.actor/input_schema.json", "**\\.actor\\input_schema.json" },
              },
            },
            validate = { enable = true },
          },
        },
      },
    },
  },
}
