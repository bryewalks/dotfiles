return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	opts = {
		filesystem = {
			filtered_items = {
				visible = true,
			},
		},
    popup_border_style = "rounded",
    use_popups_for_input = false,
    window = {
      mappings = {
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            if not node then
              vim.notify("No node selected", vim.log.levels.WARN)
              return
            end
            local filename = node.name or vim.fn.fnamemodify(node:get_id(), ":t")
            local path = node:get_id()
            local text = "#file:" .. path
            vim.fn.setreg('"', text)
            vim.notify("Copied copilot context for " .. filename)
          end,
          desc = "Copy focused file copilot context"
        },
      },
    },
	},
	config = function(_, opts)
    require("neo-tree").setup(opts)
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal right<CR>", {})
	end,
}
