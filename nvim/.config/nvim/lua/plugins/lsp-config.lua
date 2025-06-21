return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "ts_ls", "eslint", "cssls", "html" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
			lspconfig.ts_ls.setup({
        capabilities = capabilities
      })
			lspconfig.cssls.setup({
        capabilities = capabilities
      })
			lspconfig.html.setup({
        capabilities = capabilities
      })
			lspconfig.eslint.setup({
        capabilities = capabilities
      })

			vim.keymap.set("n", "<leader>g", "", { desc = "LSP"})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
			vim.keymap.set("n", "<leader>gK", vim.lsp.buf.hover, { desc = "Hover" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Go to references" })

			vim.keymap.set({ "n", "v" }, "<leader>c", "", { desc = "Code"})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
		end,
	},
}
