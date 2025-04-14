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
}
