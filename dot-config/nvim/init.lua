--- options
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.timeout = true
vim.opt.timeoutlen = 250
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.clipboard = "unnamedplus"

--- SIDE EFFECTS: EVALUATES PROFILE, LOADS LAZY PLUGINS BASED ON PROFILE
local config = require("configure")

do
    local keymapfns = config.profiles.eval(require("keymap"))
    for i = 1, #keymapfns do
        local cb = keymapfns[i]
        cb()
    end
end
