return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000,
	opts = {
		transparent_background_level = 2,
		italics = true,
		background = "hard",
	},
	config = function(_, opts)
		require("everforest").setup(opts)
		vim.cmd("colorscheme everforest")
	end,
}

