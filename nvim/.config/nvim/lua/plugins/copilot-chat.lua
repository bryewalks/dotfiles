return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "github/copilot.vim" },
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
  opts = {
    window = {
      width = 0.35,
    },
  },
  config = function(_, opts)
    require("CopilotChat").setup(opts)
    vim.api.nvim_set_keymap(
      "n",
      "<leader>cc",
      "<cmd>CopilotChatToggle<CR>",
      { noremap = true, silent = true, desc = "Copilot Chat" }
    )
  end,
}
