local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup { name = "ruff" }

-- require("lvim.lsp.manager").setup("pyright")
require("lvim.lsp.manager").setup("pylsp")
require("lvim.lsp.manager").setup("ruff_lsp")
