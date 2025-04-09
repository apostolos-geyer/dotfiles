---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      notifier = {
        enabled = (function()
          if require("profiles").profiles.vscode.applied then
            return false
          else
            return true
          end
        end)(),
      },
      gitbrowse = { enabled = true },
      lazygit = { enabled = true },
      terminal = { enabled = false },
      dashboard = {
        enabled = true,
      },
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
}
