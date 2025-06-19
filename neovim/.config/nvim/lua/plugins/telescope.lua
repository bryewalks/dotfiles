return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim", "ElPiloto/telescope-vimwiki.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>f", "", { desc = "Find" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find marks" })
      vim.keymap.set("n", "<leader>ft", builtin.git_branches, { desc = "Find git branches" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fs", builtin.spell_suggest, { desc = "Find spelling" })
			vim.keymap.set("n", "<leader>fv", "<Cmd>Telescope vimwiki live_grep<CR>", { desc = "Find vimwiki" })
			vim.keymap.set("n", "<leader>fd", "<Cmd>TodoTelescope<CR><C-[>", { desc = "Find TODOs" })
			vim.keymap.set("n", "<leader>fa", "<Cmd>Noice telescope<CR><C-[>", { desc = "Find Alerts" })
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
			require("telescope").load_extension("vimwiki")
		end,
	},
}
