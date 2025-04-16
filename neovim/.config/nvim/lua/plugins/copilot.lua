return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap(
      "i",
      "<C-a>",
      'copilot#Accept("<CR>")',
      { expr = true, silent = true, desc = "Accept Copilot suggestion" }
    )
    vim.api.nvim_set_keymap(
      "i",
      "<C-d>",
      "copilot#Dismiss()",
      { expr = true, silent = true, desc = "Dismiss Copilot suggestion" }
    )
  end,
}
