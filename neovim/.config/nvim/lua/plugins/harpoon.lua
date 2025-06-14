return {
  "ThePrimeagen/harpoon",
  opts = {
    -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
    save_on_toggle = false,

    -- saves the harpoon file upon every change. disabling is unrecommended.
    save_on_change = true,

    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    enter_on_sendcmd = false,

    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false,

    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { "harpoon" },

    -- set marks specific to each git branch inside git repository
    mark_branch = true,

    -- enable tabline with harpoon marks
    tabline = false,
    tabline_prefix = "   ",
    tabline_suffix = "   ",
  },
  config = function()
    local harpoon_mark = require("harpoon.mark");
    local harpoon_ui = require("harpoon.ui");
    vim.keymap.set("n", "<leader>h", "", { desc = "Harpoon" })
    vim.keymap.set("n", "<leader>ha", harpoon_mark.add_file, { desc = "Add file to harpoon" })
    vim.keymap.set("n", "<leader>hn", harpoon_ui.nav_next, { desc = "Go to next harpoon file" })
    vim.keymap.set("n", "<leader>hp", harpoon_ui.nav_prev, { desc = "Go to previous harpoon file" })
    vim.keymap.set("n", "<leader>hl", ":Telescope harpoon marks<CR><C-[>", { desc = "List harpoon files" })
  end,
}
