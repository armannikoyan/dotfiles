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

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
  end,

}
