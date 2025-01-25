-- replace tabs with spaces
-- and default to 4 spaces
-- this is configured per-language in after/ftplugin
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- yank to system clipboard
vim.o.clipboard = "unnamedplus"

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- make the timeout for keybinds not absurdly slow
vim.opt.timeoutlen = 100

-- Define custom filetype detection for bashls
vim.filetype.add({
  pattern = {
    -- Match files with no suffix and a shebang starting with #!/usr/bin/env bash|zsh|sh
    ["^#!/usr/bin/env%s+bash"] = "sh",
    ["^#!/usr/bin/env%s+zsh"] = "sh",
    ["^#!/usr/bin/env%s+sh"] = "sh",
  },
})
