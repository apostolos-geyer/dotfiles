-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local native = {
  { import = "plugins.themes" },
  { import = "plugins.telescope" },
  { import = "plugins.clues" },
  { import = "plugins.ui" },
  { import = "plugins.filebrowser" },
}

--- Setup lazy.nvim
require("lazy").setup(require("profiles").evaluate({
  terminal = native,
  neovide = native,
  all = {
    { import = "plugins.ui" },
    { import = "plugins.snacks" },
    { import = "plugins.programming" },
    { import = "plugins.treesitter" },
    { import = "plugins.comments" },
    { import = "plugins.games" },
    checker = { enabled = true },
  },
}))
