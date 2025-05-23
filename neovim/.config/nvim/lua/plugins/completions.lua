return {
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "mlaursen/vim-react-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      require("vim-react-snippets").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()

      local reactSnippetsConfig = require("vim-react-snippets.config")
      reactSnippetsConfig.readonly_props = false

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
      --
      -- cmp.setup.cmdline({ "/", "?" }, {
      -- 	mapping = cmp.mapping.preset.cmdline(),
      -- 	sources = {
      -- 		{ name = "buffer" },
      -- 	},
      -- })
      --
      -- cmp.setup.cmdline(":", {
      -- 	mapping = cmp.mapping.preset.cmdline(),
      -- 	sources = cmp.config.sources({
      -- 		{ name = "path" },
      -- 	}, {
      -- 		{ name = "cmdline" },
      -- 	}),
      -- 	matching = { disallow_symbol_nonprefix_matching = false },
      -- })
    end,
  },
  -- autopairing of (){}[] etc
  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
