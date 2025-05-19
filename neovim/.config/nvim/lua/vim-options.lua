vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100",
}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Easier visual movements
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the highlighted line(s) down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the highlighted line(s) up" })

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', { desc = "Move to the pane above" })
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', { desc = "Move to the pane below" })
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', { desc = "Move to the pane left" })
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', { desc = "Move to the pane right" })

-- Rebind c-i to itself to distinguish between c-i and tab
vim.keymap.set('n', '<c-i>', '<c-i>')

-- Recenter the screen after <c-u> and <c-d>
vim.keymap.set('n', '<c-u>', '<c-u>zz', { desc = "Scroll up half a page and recenter" })
vim.keymap.set('n', '<c-d>', '<c-d>zz', { desc = "Scroll down half a page and recenter" })
--recenter the screen after searching
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Search next and recenter" })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Search previous and recenter" })

-- System clipboard helpers
-- Yank into system clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = "yank to clipboard motion" })
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y', { desc = "yank to clipboard line" })
-- Delete into system clipboard
vim.keymap.set({'n', 'v'}, '<leader>d', '"+d', { desc = "delete to clipboard motion" })
vim.keymap.set({'n', 'v'}, '<leader>D', '"+D', { desc = "delete to clipboard line" })
-- Paste from system clipboard
vim.keymap.set('n', '<leader>p', '"+p', { desc = "paste from clipboard after cursor" })
vim.keymap.set('n', '<leader>P', '"+P', { desc = "paste from clipboard before cursor" })

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})
