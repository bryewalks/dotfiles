return {
	"smoka7/hop.nvim",
	version = "*",
	opts = {
		keys = "etovxqpdygfblzhckisuran",
	},
	config = function()
		require("hop").setup()
		vim.api.nvim_set_keymap("n", "<Leader><Leader>b", "<cmd>HopWordBC<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<Leader><Leader>w", "<cmd>HopWordAC<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<Leader><Leader>j", "<cmd>HopLineStartAC<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<Leader><Leader>k", "<cmd>HopLineStartBC<CR>", { noremap = true })

		vim.api.nvim_set_keymap("v", "<Leader><Leader>w", "<cmd>HopWordAC<CR>", { noremap = true })
		vim.api.nvim_set_keymap("v", "<Leader><Leader>b", "<cmd>HopWordBC<CR>", { noremap = true })
		vim.api.nvim_set_keymap("v", "<Leader><Leader>j", "<cmd>HopLineAC<CR>", { noremap = true })
		vim.api.nvim_set_keymap("v", "<Leader><Leader>k", "<cmd>HopLineBC<CR>", { noremap = true })
		vim.cmd.hi("HopNextKey guifg=#8be9fd")
		vim.cmd.hi("HopNextKey1 guifg=#ff79c6")
		vim.cmd.hi("HopNextKey2 guifg=#bd93f9")
		-- hi HopNextKey1 guifg=#f7wf38
		-- hi HopNextKey2 guifg=#f7wf38
	end,
}
