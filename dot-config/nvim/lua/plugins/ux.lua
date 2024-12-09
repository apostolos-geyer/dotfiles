---@type LazySpec
return {
  -- block comment
  {
    "echasnovski/mini.comment",
    version = false,
    config = function()
      require("mini.comment").setup({
        mappings = {
          comment = "<leader><Space>/",
          comment_line = "<leader>/",
          comment_visual = "<leader>/",
          textobject = "<leader>/",
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },
  -- misc
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      notifier = { enabled = true },
      gitbrowse = { enabled = true },
      lazygit = { enabled = true },
      terminal = { enabled = true },
    },
    keys = {
      {
        "<leader>Gol",
        function()
          Snacks.lazygit()
        end,
        desc = "[G]it [o]pen in [l]azygit",
      },
      {
        "<leader>Gob",
        function()
          Snacks.gitbrowse()
        end,
        desc = "[G]it [o]pen in a [b]rowser",
      },
    },
  },
  {
    "echasnovski/mini.clue",
    version = false,
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
  },
}
