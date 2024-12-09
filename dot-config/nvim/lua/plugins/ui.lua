---@type LazySpec
return {
  -- bufferline & icons
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup()
    end,
  },

  -- statusline
  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup({})
    end,
  },

  -- other icons
  { "echasnovski/mini.icons", version = false },

  -- nice animations on movement
  {
    "echasnovski/mini.animate",
    version = false,
    config = function()
      require("mini.animate").setup({})
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim", -- UI components
      -- Snacks.nvim will handle notifications
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            -- Override LSP hover and signature help with Noice UI
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true, -- Use a classic bottom search bar
          command_palette = true, -- Use a clean command palette
          long_message_to_split = true, -- Long messages in a split
          inc_rename = false, -- Disable Noice renaming UI
        },
        notify = {
          enabled = false, -- Disable Noice's notify integration since Snacks.nvim is in use
        },
      })
    end,
  },
}
