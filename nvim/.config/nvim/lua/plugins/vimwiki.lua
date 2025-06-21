return {
  "vimwiki/vimwiki",
  init = function()
    vim.keymap.set('n', '<leader>w', '', { noremap = true, desc = 'Wiki' })
    vim.g.vimwiki_list = {
      {
        path = '~/Documents/Markdown/vimwiki',
        syntax = 'markdown',
        ext = '.md',
      },
    }
  end
}
