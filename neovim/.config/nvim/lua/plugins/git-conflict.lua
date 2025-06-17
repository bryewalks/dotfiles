return {
  "akinsho/git-conflict.nvim",
  version = "*",
  opts = {
      default_mappings = {
        ours = 'co',
        theirs = 'ct',
        none = 'cx',
        both = 'cb',
        next = 'cn',
        prev = 'cp',
      }
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { bg = "#BD93F9", fg = "#44475A" })
    vim.api.nvim_set_hl(0, "GitConflictIncoming", { bg = "#E9DBFD", fg = "#44475A" })
    vim.api.nvim_set_hl(0, "GitConflictCurrentLabel", { bg = "#50FA7B", fg = "#44475A" })
    vim.api.nvim_set_hl(0, "GitConflictCurrent", { bg = "#9AFCB3", fg = "#44475A" })
    require("git-conflict").setup(opts)
  end,
}
