return {
  "armannikoyan/rusty",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    italic_comments = true,
    underline_current_line = true,
  },

  config = function(_, opts)
    require("rusty").setup(opts)
  end,
}
