--- @type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({})
  end,
  keys = {
    {
      "<leader>Fw",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown({ winblend = 10, previewer = true, mirror = true })
        )
      end,
      desc = "[F]uzz [w]ords (in current file)",
      mode = "n",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").fd(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = true,
          mirror = true,
          hidden = true,
        }))
      end,
      desc = "[f]ind [f]iles",
      mode = "n",
    },
    {
      "<leader>fst",
      function()
        require("telescope.builtin").treesitter()
      end,
      desc = "[f]ind [s]ymbols with [t]reesitter",
      mode = "n",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "[f]ind [w]ords (grep)",
      mode = { "n", "v" },
    },
    {
      "<leader>fiw",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "[f]ind [i]n [w]orkspace (ripgrep)",
      mode = "n",
    },
    { "gd", require("telescope.builtin").lsp_definitions,      mode = "n", desc = "[g]o to [d]efinition" },
    { "gr", require("telescope.builtin").lsp_references,       mode = "n", desc = "[g]et [r]eferences" },
    { "gi", require("telescope.builtin").lsp_implementations,  mode = "n", desc = "[g]o to [i]mplementation" },
    { "gt", require("telescope.builtin").lsp_type_definitions, mode = "n", desc = "[g]o to [t]ype definition" },
    {

      "<leader>ls",
      require("telescope.builtin").lsp_document_symbols,
      desc = "[l]ist [s]ymbols in document",
      mode = "n",
    },
    {

      "<leader>lS",
      require("telescope.builtin").lsp_workspace_symbols,
      desc = "[l]ist [S]ymbols in workspace",
      mode = "n",
    },
    {

      "<leader>ld",
      function()
        require("telescope.builtin").diagnostics({ bufnr = 0 })
      end,
      desc = "[l]sp [d]iagnostics (current buffer)",
      mode = "n",
    },
    {

      "<leader>lD",
      require("telescope.builtin").diagnostics,
      desc = "[l]anguage server [D]iagnostics (all buffers)",
      mode = "n",
    },
  },
}
