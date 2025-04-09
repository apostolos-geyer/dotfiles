--- @type LazySpec
return {
  --- bufferline (top)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup()
    end,
    keys = {
      { "<leader>bb",  "<CMD>BufferLinePick<CR>",      mode = "n", desc = "[b]uffer pick" },
      { "<leader>bc",  "<CMD>bdelete<CR>",             mode = "n", desc = "[c]lose buffer (current)" },
      { "<leader>blc", "<CMD>BufferLinePickClose<CR>", mode = "n", desc = "[b]uffer [l]ine [c]lose" },
      { "<leader>b]",  "<CMD>BufferLineCycleNext<CR>", mode = "n", desc = "next buffer" },
      { "<leader>b[",  "<CMD>BufferLineCyclePrev<CR>", mode = "n", desc = "previous buffer" },
    },
  },

  --- statusline (bottom)
  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup({})
    end,
  },

  --- icons
  { "echasnovski/mini.icons", version = false },
}
