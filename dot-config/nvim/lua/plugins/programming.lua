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
            lsp.lua_ls.setup({})
            lsp.basedpyright.setup({})
            lsp.ruff.setup({})
            lsp.gopls.setup({})
            lsp.zls.setup({})
            lsp.bashls.setup({
                filetypes = { "bash", "zsh", "sh" },
            })
            lsp.nushell.setup({})
            lsp.denols.setup({})
        end,
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
            "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
            "hrsh7th/cmp-buffer", -- Buffer source
            "hrsh7th/cmp-path", -- Path source
            "hrsh7th/cmp-cmdline", -- Command-line completions
            "L3MON4D3/LuaSnip", -- Snippets engine
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
                    ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
                    ["<Tab>"] = cmp.mapping.select_next_item(), -- Next item
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Previous item
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
                fast_wrap = {}, -- Optional: Fast wrapping using `<M-e>`
            })
        end,
    },
    -- { -- disabling copilot because it is not very smart # thanks for completing it copilot :)
    -- 	"github/copilot.vim",
    -- 	event = "InsertEnter",
    -- 	config = function()
    -- 		vim.g.copilot_no_tab_mode = true
    -- 		vim.keymap.set("i", "<Leader><Tab>", 'copilot#Accept("<Tab>")', {
    -- 			expr = true, -- Treat the mapping as an expression
    -- 			replace_keycodes = false, -- Prevent Neovim from interpreting <Tab>
    -- 			silent = true,
    -- 			desc = "Accept Copilot suggestion",
    -- 		})
    -- 		vim.api.nvim_set_keymap("i", "<C-space>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    -- 		vim.g.copilot_filetypes = { ["*"] = true }
    -- 	end,
    -- },
}
