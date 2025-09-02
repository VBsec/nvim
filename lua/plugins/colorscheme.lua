return {
	{ "nxvu699134/vn-night.nvim" },
	{ "folke/tokyonight.nvim" },
	{ "ellisonleao/gruvbox.nvim" },
	{
		"Shatur/neovim-ayu",
		config = function()
			require("ayu").setup({
				-- overrides = {
				-- 	Normal = { bg = "None" },
				-- 	ColorColumn = { bg = "None" },
				-- 	SignColumn = { bg = "None" },
				-- 	Folded = { bg = "None" },
				-- 	FoldColumn = { bg = "None" },
				-- 	CursorLine = { bg = "None" },
				-- 	CursorColumn = { bg = "None" },
				-- 	WhichKeyFloat = { bg = "None" },
				-- 	VertSplit = { bg = "None" },
				-- },
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			style = "night",
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},
	{ "rose-pine/neovim", name = "rose-pine" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight",
		},
	},
}
