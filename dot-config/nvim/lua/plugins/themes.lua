return {
    {
        "xero/miasma.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            vim.cmd("colorscheme miasma")
        end,
    },
    {
        "olivercederborg/poimandres.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("poimandres").setup({})
        end,
    },
    -- lua/plugins/colorscheme.lua (or wherever you configure plugins)
    {
        "NLKNguyen/papercolor-theme",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = "light" -- important!
            -- vim.cmd.colorscheme("PaperColor")
        end,
    },
}
