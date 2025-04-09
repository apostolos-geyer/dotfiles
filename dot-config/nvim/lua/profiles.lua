local nvprofile = require("nvprofile")
local available = nvprofile.util.gavailable

return nvprofile.setup(
--- @type { [string]: ProfileCfg }
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
        vim.g.neovide_opacity = 0.75
        vim.g.neovide_window_blurred = true

        -- resize +
        vim.keymap.set(
          "n",
          "<D-=>",
          ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
          { silent = true }
        )

        -- resize -
        vim.keymap.set(
          "n",
          "<D-->",
          ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
          { silent = true }
        )

        -- reset size
        vim.keymap.set("n", "<D-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })
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
