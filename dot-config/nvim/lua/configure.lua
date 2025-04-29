require("bootstrap_lazy")()

local M = { configured = false }

--- setup my little profile system
do
  local available = require("nvprofile").util.gavailable
  M.profiles = require("nvprofile").setup(
  ---@type { [string]: ProfileCfg }
    {
      terminal = {
        cond = function()
          return vim.g.vscode == nil and vim.g.neovide == nil
        end,
        apply = function()
          return true
        end,
      },
      neovide = {
        cond = available("neovide"),
        apply = function()
          vim.g.neovide_opacity = 0.88
          vim.g.neovide_window_blurred = true
          return true
        end,
      },
      vscode = {
        cond = available("vscode"),
        apply = function()
          local vscode = require("vscode")
          vim.notify = vscode.notify
          return true
        end,
      },
    }
  )
end

--- load plugins via lazy
do
  M.profiles.activate()   -- set active flags
  local when = require("nvprofile.predicates").when
  local enabled = { enabled = true }
  local plugins = M.profiles.eval({
    [when.always] = {
      {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = M.profiles.eval({
          [when.any_of("terminal", "neovide")] = {
            indent = enabled,
            gitbrowse = enabled,
            lazygit = enabled,
            dashboard = enabled,
            notifier = enabled,
            image = enabled,
            dim = {
              enabled = true,
              scope = {
                min_size = 5,
                max_size = 20,
                siblings = false,
              },
              -- animate scopes. Enabled by default for Neovim >= 0.10
              -- Works on older versions but has to trigger redraws during animation.
              ---@type snacks.animate.Config|{enabled?: boolean}
              animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                easing = "outQuad",
                duration = {
                  step = 20,                     -- ms per step
                  total = 300,                   -- maximum duration
                },
              },
              -- what buffers to dim
              filter = function(buf)
                return vim.g.snacks_dim ~= false
                    and vim.b[buf].snacks_dim ~= false
                    and vim.bo[buf].buftype == ""
              end,
            },
          },
          vscode = {
            gitbrowse = enabled,
          },
        }, 1),
      },
      { import = "plugins.comments" },
      checker = { enabled = true },
    },
    [when.any_of("terminal", "neovide")] = {
      { import = "plugins.programming" },
      { import = "plugins.completion" },
      { import = "plugins.snippets" },
      { import = "plugins.treesitter" },
      { import = "plugins.themes" },
      { import = "plugins.telescope" },
      { import = "plugins.clues" },
      { import = "plugins.ui" },
      { import = "plugins.filebrowser" },
      { import = "plugins.noice" },
      { import = "plugins.games" },
    },
    terminal = {
      { "typicode/bg.nvim", lazy = false },
    },
  }, 1)
  M.plugins = plugins
end

require("lazy").setup(M.plugins)

return M
