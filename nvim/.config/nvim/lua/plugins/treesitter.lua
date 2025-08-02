return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
    auto_install = true,
		highlight = { enable = true },
		indent = { enabled = true },
	},
  config = function()
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { "*.tsx", "*ts", "*.jsx", "*.js" },
      callback = function()
        vim.cmd("TSBufEnable highlight")
      end,
    })
  end,
}
