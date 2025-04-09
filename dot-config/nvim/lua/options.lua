for _, fn in
ipairs(require("profiles").evaluate({
  all = function()
    vim.opt.expandtab = true
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 4
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.o.clipboard = "unnamedplus"
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"
    vim.opt.timeoutlen = 100
  end,
}))
do
  fn()
end
