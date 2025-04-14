--- @type LazySpec
---
---

local textobj_clues = function()
  local base = { { keys = "a", desc = "around: " }, { keys = "i", desc = "in: " } }
  local textobjs = {
    { keys = "w", desc = "word" },
    { keys = "W", desc = "WORD" },
    { keys = "s", desc = "sentence" },
    { keys = "p", desc = "paragraph" },
    { keys = "b", desc = "() block" },
    { keys = "B", desc = "[] block" },
    { keys = "t", desc = "<tag>" },
    { keys = "<", desc = "<>" },
    { keys = "[", desc = "[]" },
    { keys = '"', desc = '"string"' },
    { keys = "'", desc = "'string'" },
    { keys = "`", desc = "`string`" },
    { keys = "f", desc = "function" },
    { keys = "c", desc = "class" },
    { keys = "l", desc = "loop" },
  }

  local extra_clues = {}

  for _, grp in ipairs(base) do
    table.insert(extra_clues, { mode = "v", keys = grp.keys, desc = grp.desc })
    for _, to in ipairs(textobjs) do
      table.insert(extra_clues, { mode = "v", keys = grp.keys .. to.keys, desc = grp.desc .. to.desc })
    end
  end

  return extra_clues
end

return {
  "echasnovski/mini.clue",
  version = false,
  config = function()
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

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
      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        textobj_clues(),
      },
      window = {
        delay = 200,
        width = "auto",
      },
    })
  end,
}
