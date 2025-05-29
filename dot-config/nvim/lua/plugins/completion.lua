return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",     -- LSP source for nvim-cmp
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-buffer",           -- Buffer source
    "hrsh7th/cmp-path",             -- Path source
    "hrsh7th/cmp-cmdline",          -- Command-line completions
    "L3MON4D3/LuaSnip",             -- Snippets engine
    "saadparwaiz1/cmp_luasnip",     -- Snippet completions
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- thank you https://github.com/ryanburda/config/blob/5c3737346b20cbc8d12d225c62b25fc0730c8512/dotfiles/nvim/lua/plugins/configs/nvim-cmp.lua#L8-L34
    local is_whitespace = function()
      -- returns true if the character under the cursor is whitespace.
      local col = vim.fn.col(".") - 1
      local line = vim.fn.getline(".")
      local char_under_cursor = string.sub(line, col, col)

      if col == 0 or string.match(char_under_cursor, "%s") then
        return true
      else
        return false
      end
    end

    local is_comment = function()
      -- uses treesitter to determine if cursor is currently in a comment.
      local context = require("cmp.config.context")
      return context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment")
    end

    cmp.setup({
      enabled = function()
        if is_comment() or is_whitespace() then
          return false
        else
          return true
        end
      end,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),                    -- Trigger completion
        ["<CR>"] = cmp.mapping.confirm({ select = true }),         -- Confirm selection
        ["<Tab>"] = cmp.mapping.select_next_item(),                -- Next item
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),              -- Previous item
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "cmp_nvim_lsp_signature_help" },
        { name = "cmp_nvim_lsp_document_symbol" },
        { name = "buffer" },
        { name = "path" },
        { name = "cmdline" },
        -- { name = "luasnip" },
      },
    })
  end,
}
