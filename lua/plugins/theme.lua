return{
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		opt = { },
	},
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 100,
		config = function()
			require('bamboo').load()
		end
	},
	{
		"rebelot/kanagawa.nvim",
		lazy=false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = true,
			})
		end
	}
}
