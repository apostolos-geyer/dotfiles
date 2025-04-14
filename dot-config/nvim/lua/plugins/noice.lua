---@type LazySpec
return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim", -- UI components
        -- Snacks.nvim will handle notifications
    },
    config = function()
        --- says missing fields but it's fine
        --- @diagnostic disable-next-line
        require("noice").setup({
            lsp = {
                override = {
                    -- Override LSP hover and signature help with Noice UI
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                command_palette = true, -- Use a clean command palette
                long_message_to_split = true, -- Long messages in a split
            },
        })
    end,
}
