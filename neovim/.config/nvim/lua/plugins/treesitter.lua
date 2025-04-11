return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
    auto_install = true,
		hightlight = { enable = true },
		indent = { enabled = true },
	},
}
