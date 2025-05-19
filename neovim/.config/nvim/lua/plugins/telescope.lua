return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>f", "", { desc = "Find" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find marks" })
      vim.keymap.set("n", "<leader>fb", builtin.git_branches, { desc = "Find git branches" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
}
