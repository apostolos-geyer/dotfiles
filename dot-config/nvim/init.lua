require("options")
require("lazyinit")
require("binds")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })      -- Main background
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })    -- Inactive windows
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" }) -- ~ symbols
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })  -- Sign column (left gutter)
