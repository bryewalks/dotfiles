return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Navigate to the pane left (Tmux)" } },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", { desc = "Navigate to the pane below (Tmux)" } },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", { desc = "Navigate to the pane above (Tmux)" } },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", { desc = "Navigate to the pane right (Tmux)" } },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", { desc = "Navigate to the previous pane (Tmux)" } },
  },
}
