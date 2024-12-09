--- @param dest table The destination table to append to.
--- @param src table The source table to append from.
local extend = function(dest, src)
  table.move(src, 1, #src, #dest + 1, dest)
end

local kms = function(btbl, modes, keys, fn, desc)
  for _, mode in ipairs(modes) do
    table.insert(btbl, { mode = mode, keys = keys, desc = desc })
  end
  vim.keymap.set(modes, keys, fn, { desc = desc, noremap = true, silent = true })
end

-- LSP -- keep in sync with programming.lua lsp init
local binds_lsp = function()
  local buf = vim.lsp.buf
  local binds = {
    -- LSP Navigation
    [{ key = "gd", desc = "[g]o to [d]efinition" }] = buf.definition,
    [{ key = "gD", desc = "[g]o to [D]eclaration" }] = buf.declaration,
    [{ key = "gr", desc = "[g]et [r]eferences" }] = buf.references,
    [{ key = "gi", desc = "[g]o to [i]mplementation" }] = buf.implementation,
    [{ key = "gt", desc = "[g]o to [t]ype definition" }] = buf.type_definition,
    [{ key = "gh", desc = "[g]et [h]over info" }] = buf.hover,
    [{ key = "gs", desc = "[g]et [s]ignature" }] = buf.signature_help,
    [{ key = "gnn", desc = "[g]ive [n]ew [n]ame" }] = buf.rename,
    [{ key = "<leader>ls", desc = "[l]ist [s]ymbols in document" }] = buf.document_symbol,
    [{ key = "<leader>lS", desc = "[l]ist [S]ymbols in workspace" }] = buf.workspace_symbol,
    [{ key = "<leader>la", desc = "[l]anague server code [a]ctions" }] = buf.code_action,
  }
  -- Function to set LSP keybindings
  local function set_lsp_keymaps(bufnr)
    -- if keymaps of this buffer are already set we
    -- dont need to do it again
    if vim.b[bufnr].lsp_keymaps_set then
      return
    end
    -- Set the keybindings for the attached buffer
    for key_data, fn in pairs(binds) do
      local key, desc = key_data.key, "LSP: " .. key_data.desc
      vim.keymap.set("n", key, fn, { noremap = true, silent = true, desc = desc, buffer = bufnr })
    end

    vim.b[bufnr].lsp_keymaps_set = true -- mark keymaps as set for buffer
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      -- If LSP supports formatting
      if client.supports_method("textDocument/formatting") then
        -- Right before save, call vim.lsp.buf.format
        local buf = args.buf
        set_lsp_keymaps(buf)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = buf, id = client.id })
          end,
        })
      end
    end,
  })

  local btbl = {
    { mode = "n", keys = "g", desc = "goto/get..." },
    {
      mode = "n",
      keys = "<leader>l",
      desc = "language server...",
    },
  }
  for info, _ in pairs(binds) do
    table.insert(btbl, { mode = "n", keys = info.key, desc = info.desc })
  end
  return btbl
end

-- BUFFERLINE --
local binds_bufferline = function()
  local btbl = {}
  local binds = {
    [{ keys = "<leader>bs", desc = "[b]uffer [s]witch" }] = "<CMD>BufferLinePick<CR>",
    [{ keys = "<leader>bc", desc = "[b]uffer [c]lose (current)" }] = "<CMD>bdelete<CR>",
    [{ keys = "<leader>blc", desc = "[b]uffer [l]ine [c]lose (close from line)" }] = "<CMD>BufferLinePickClose<CR>",
    [{ keys = "<leader>b[", desc = "next buffer" }] = "<CMD>BufferLineCycleNext<CR>",
    [{ keys = "<leader>b]", desc = "previous buffer" }] = "<CMD>BufferLineCyclePrev<CR>",
  }
  for data, fn in pairs(binds) do
    kms(btbl, data.modes or { "n" }, data.keys, fn, data.desc)
  end
  table.insert(btbl, { mode = "n", keys = "<leader>b", desc = "buffer..." })
  return btbl
end

-- TELESCOPE --
local binds_telescope = function()
  local btbl = {}
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")
  local binds = {
    [{ keys = "<leader>Fw", desc = "[F]uzz [w]ords (in current file)" }] = function()
      builtin.current_buffer_fuzzy_find(themes.get_dropdown({
        winblend = 10,
        previewer = true,
        mirror = true,
      }))
    end,
    [{ keys = "<leader>ff", desc = "[f]ind [f]iles" }] = function()
      builtin.fd(themes.get_dropdown({
        winblend = 10,
        previewer = true,
        mirror = true,
        hidden = true,
      }))
    end,
    [{ keys = "<leader>fst", desc = "[f]ind [s]ymbols with [t]reesitter" }] = builtin.treesitter,
    [{ keys = "<leader>fw", desc = "[f]ind [w]ords (grep)", modes = { "n", "v" } }] = builtin.grep_string,
    [{ keys = "<leader>fiw", desc = "[f]ind [i]n [w]orkspace (ripgrep)" }] = builtin.live_grep,
  }
  for data, fn in pairs(binds) do
    kms(btbl, data.modes or { "n" }, data.keys, fn, data.desc)
  end
  extend(
    btbl,
    { { keys = "<leader>f", desc = "[f]ind...", mode = "n" }, { keys = "<leader>f", desc = "[f]ind...", mode = "v" } }
  )
  return btbl
end

--- MINICLUE SETUP ---

--- mini clue doesnt provide this for some reason
local binds_visual = function()
  local base = { { keys = "a", desc = "Around...+" }, { keys = "i", desc = "Inside..." } }
  local textobjs = {
    { keys = "w", desc = "word ([a-zA-Z_])" },
    { keys = "W", desc = "word (contiguous block of characters)" },
    { keys = "s", desc = "sentence" },
    { keys = "p", desc = "paragraph" },
    { keys = "b", desc = "parenthesized () block" },
    { keys = "B", desc = "bracketed [] block" },
    { keys = "t", desc = "<tag> block" },
    { keys = "<", desc = "angle bracketed <> block" },
    { keys = "[", desc = "square bracketed [] block" },
    { keys = '"', desc = "double quoted string" },
    { keys = "'", desc = "single quoted string" },
    { keys = "`", desc = "backticked string" },
  }
  local tbl = {}
  for _, grp in ipairs(base) do
    table.insert(tbl, { mode = "v", keys = grp.keys, desc = grp.desc })
    for _, to in ipairs(textobjs) do
      table.insert(tbl, { mode = "v", keys = grp.keys .. to.keys, desc = grp.desc .. " " .. to.desc })
    end
  end
  return tbl
end;

(function()
  local miniclue = require("mini.clue")
  local clues = {}
  extend(clues, binds_visual())
  extend(clues, binds_bufferline())
  extend(clues, binds_telescope())
  extend(clues, binds_lsp())
  extend(clues, {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  })

  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },

      -- visual mode
      { mode = "v", keys = "<Leader>" },
      { mode = "v", keys = "i" },
      { mode = "v", keys = "a" },

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
    clues = clues,
    window = {
      delay = 200,
    },
  })
end)()
