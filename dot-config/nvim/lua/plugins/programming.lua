---@type LazySpec
local config = {
  {
    "neovim/nvim-lspconfig",
    -- name = "nvim-lspconfig",
    -- dir = "/Users/stoli/Desktop/dev/nvim-lspconfig",
    -- dev = true,
    ---@type LazySpec
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            "lazy.nvim",
            "snacks.nvim",
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local lsp = require("lspconfig")
      local util = require("lspconfig.util")
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function without(capabilities, keys_to_disable)
        local new = vim.deepcopy(capabilities)
        for _, key in ipairs(keys_to_disable) do
          local segments = vim.split(key, ".", { plain = true })
          local ref = new
          for i = 1, #segments - 1 do
            ref = ref[segments[i]]
            if not ref then
              break
            end
          end
          if ref then
            ref[segments[#segments]] = nil
          end
        end
        return new
      end

      -- LSPs
      lsp.lua_ls.setup({})
      lsp.basedpyright.setup({})
      lsp.ruff.setup({})
      lsp.gopls.setup({})
      lsp.zls.setup({})
      lsp.svelte.setup({})
      lsp.bashls.setup({
        filetypes = { "bash", "zsh", "sh" },
      })
      lsp.nushell.setup({})
      lsp.denols.setup({
        root_dir = lsp.util.root_pattern("deno.json", "deno.jsonc"),
      })
      lsp.astro.setup({})
      lsp.clangd.setup({})

      -- 🧠 Lexical for completions, hover, HEEx support
      lsp.lexical.setup({
        cmd = { vim.fn.expand("~/.local/src/lexical/_build/dev/package/lexical/bin/start_lexical.sh") },
        root_dir = function(fname)
          return util.root_pattern("mix.exs", ".git")(fname) or vim.uv.cwd()
        end,
        filetypes = { "elixir", "eelixir", "heex" },
        capabilities = without(cmp_capabilities, {
          "textDocument.codeLens",
          "textDocument.references",
          "textDocument.implementation",
          "textDocument.typeDefinition",
          "workspace.executeCommand",
        }),
      })

      -- 🧠 ElixirLS for Dialyzer, CodeLens, and references
      lsp.elixirls.setup({
        cmd = { vim.fn.expand("~/.local/src/elixir-ls/release/language_server.sh") },
        root_dir = util.root_pattern("mix.exs", ".git"),
        filetypes = { "elixir", "eelixir", "heex" },
        capabilities = without(cmp_capabilities, {
          "textDocument.completion",
          "textDocument.hover",
          "textDocument.definition",
          "textDocument.documentHighlight",
          "textDocument.semanticTokens",
          "textDocument.codeAction",
          "textDocument.publishDiagnostics",
        }),
        settings = {
          elixirLS = {
            dialyzerEnabled = true,
            fetchDeps = false,
          },
        },
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({})
    end,
  },
  {
    "davidmh/mdx.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = (function()
        local web = { "prettierd", "prettier", stop_after_first = true }
        return {
          lua = { "stylua" },
          python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
          json = { "jq" },
          go = { "gofumpt", "goimports" },
          javascript = web,
          typescript = web,
          html = web,
          css = web,
          zig = { "zigfmt" },
          templ = { "templ" },
        }
      end)(),
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
      log_level = vim.log.levels.ERROR,
      notify_on_error = true,
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer",       -- Buffer source
      "hrsh7th/cmp-path",         -- Path source
      "hrsh7th/cmp-cmdline",      -- Command-line completions
      "L3MON4D3/LuaSnip",         -- Snippets engine
      "saadparwaiz1/cmp_luasnip", -- Snippet completions
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),            -- Trigger completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
          ["<Tab>"] = cmp.mapping.select_next_item(),        -- Next item
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),      -- Previous item
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        },
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        enable_check_bracket_line = true, -- Add a check if the line already has brackets
        fast_wrap = {},                   -- Optional: Fast wrapping using `<M-e>`
      })
    end,
  },
}

return require("profiles").evaluate({
  vscode = {},
  terminal = config,
  neovide = config,
})
