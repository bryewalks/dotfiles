return {
   "rcarriga/nvim-notify",
   opts = {},
   config = function()
      local notify = require("notify")
      notify.setup({
        timeout = 1000,
        top_down = false,
      })
      vim.notify = notify
   end,
}
