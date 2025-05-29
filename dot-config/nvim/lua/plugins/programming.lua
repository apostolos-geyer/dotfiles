---@type LazySpec
return {
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
      lsp.ruff.setup({
        capabilities = without(cmp_capabilities, { "textDocument.hover" }),
      })
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
      lsp.mdx_analyzer.setup({})

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

      local binds_lsp = function()
        local buf = vim.lsp.buf
        local binds = {
          { "n", "gD",         buf.declaration,    "[g]o to [D]eclaration" },
          { "n", "gh",         buf.hover,          "[g]et [h]over info" },
          { "n", "gs",         buf.signature_help, "[g]et [s]ignature" },
          { "n", "<leader>lr", buf.rename,         "[l]sp [r]ename" },
          { "n", "<leader>la", buf.code_action,    "[l]sp code [a]ctions" },
        }

        local function set_lsp_keymaps(bufnr)
          if vim.b[bufnr].lsp_keymaps_set then
            return
          end
          for _, b in ipairs(binds) do
            vim.keymap.set(b[1], b[2], b[3], { desc = "LSP: " .. b[4], noremap = true, silent = true })
          end
          vim.b[bufnr].lsp_keymaps_set = true
        end

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then
              return
            end

            if client.name == "ruff" then
              client.server_capabilities.hoverProvider = false
            end

            local bufnr = args.buf
            set_lsp_keymaps(bufnr)

            vim.notify(string.format("lsp attached: %s %d", client.name, bufnr))

            if client.supports_method("textDocument/formatting", bufnr) then
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
                end,
              })
            end
          end,
        })
      end
      binds_lsp()
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        enable_check_bracket_line = true,         -- Add a check if the line already has brackets
        fast_wrap = {},                           -- Optional: Fast wrapping using `<M-e>`
      })
    end,
  },
}
