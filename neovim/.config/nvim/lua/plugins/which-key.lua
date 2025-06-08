return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>b",
      "",
      desc = "Buffer",
    },
    {
      "<leader>o",
      "",
      desc = "Other",
    },
    {
      "<leader>bw",
      "<cmd>WhichKey<CR>",
      desc = "Which Key",
    },
    {
      "<leader>b?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
