return {
	"numToStr/Comment.nvim",
	keys = {
		{ "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
		{ "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
		{ "gbc", mode = "n", desc = "Comment toggle current block" },
	},
	config = function()
		require("Comment").setup({})
	end,
}
