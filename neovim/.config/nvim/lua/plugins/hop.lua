return {
	"smoka7/hop.nvim",
	version = "*",
	opts = {
		keys = "etovxqpdygfblzhckisuran",
	},
	config = function()
		require("hop").setup()
		vim.keymap.set({'n', 'v'}, "<Leader><Leader>", "", { noremap = true, desc = "Easy Motions" })
		vim.keymap.set({'n', 'v'}, "<Leader><Leader>b", "<cmd>HopWordBC<CR>", { noremap = true, desc = "Hop Word Backwards" })
		vim.keymap.set({'n', 'v'}, "<Leader><Leader>w", "<cmd>HopWordAC<CR>", { noremap = true, desc = "Hop Word Forwards" })
		vim.keymap.set({'n', 'v'}, "<Leader><Leader>j", "<cmd>HopLineStartAC<CR>", { noremap = true, desc = "Hop Line Start Forwards" })
		vim.keymap.set({'n', 'v'}, "<Leader><Leader>k", "<cmd>HopLineStartBC<CR>", { noremap = true, desc = "Hop Line Start Backwards" })
		vim.keymap.set({'n', 'v'}, "<Leader><Leader>l", "<cmd>HopWordCurrentLine<CR>", { noremap = true, desc = "Hop Word Current Line" })
		vim.keymap.set({'n', 'v'}, "<Leader><Leader>f", "<cmd>HopChar2<CR>", { noremap = true, desc = "Hop Find Chars 2" })

		vim.cmd.hi("HopNextKey guifg=#8be9fd")
		vim.cmd.hi("HopNextKey1 guifg=#ff79c6")
		vim.cmd.hi("HopNextKey2 guifg=#bd93f9")
	end,
}
