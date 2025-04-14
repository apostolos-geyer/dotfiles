vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--- SIDE EFFECTS: EVALUATES PROFILE, LOADS LAZY PLUGINS BASED ON PROFILE
local config = require("configure")

do
  local keymapfns = config.profiles.eval(require("keymap"))
  for i = 1, #keymapfns do
    local cb = keymapfns[i]
    cb()
  end
end
