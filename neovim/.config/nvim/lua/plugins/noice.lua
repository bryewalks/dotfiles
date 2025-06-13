return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		local noice = require("noice")
		noice.setup({
			routes = {
				{
					view = "notify",
					filter = { event = "msg_showmode" },
				},
			},
		})
	end,
}
