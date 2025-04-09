--- @type LazySpec
return {
  "echasnovski/mini.comment",
  version = false,
  config = function()
    require("mini.comment").setup({
      mappings = {
        comment = "<leader><Space>/",
        comment_line = "<leader>/",
        comment_visual = "<leader>/",
        textobject = "<leader>/",
      },
    })
  end,
}
