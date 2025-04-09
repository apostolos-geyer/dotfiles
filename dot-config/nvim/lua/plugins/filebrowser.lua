--- @type LazySpec
return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  init = function()
    require("oil").setup({})
  end,
  keys = {
    { "<leader>e", "<CMD>Oil<CR>", mode = "n", desc = "[e]xplorer (oil)" },
  },
}
