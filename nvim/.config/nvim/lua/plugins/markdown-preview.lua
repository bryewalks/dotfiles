return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install && git restore .",
  ft = { "markdown" },
  config = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.keymap.set('n', '<leader>om', '<CMD>MarkdownPreviewToggle<CR>', { noremap = true, desc = 'Markdown Toggle' })
  end,
}
