local icons = require("config.icons")
return {

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")
      local check_backspace = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_next_item()
             elseif luasnip.jumpable(1) then
               luasnip.jump(1)
             elseif luasnip.expand_or_jumpable() then
               luasnip.expand_or_jump()
             elseif luasnip.expandable() then
               luasnip.expand()
             elseif check_backspace() then
               fallback()
             else
               fallback()
             end
           end, {
             "i",
             "s",
           }),
           ["<S-Tab>"] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_prev_item()
             elseif luasnip.jumpable(-1) then
               luasnip.jump(-1)
             else
               fallback()
             end
           end, {
             "i",
             "s",
           }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("config.icons")
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },

  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  -- Fast and feature-rich surround actions. For text that includes
  -- surrounding characters like brackets or quotes, this allows you
  -- to select the text inside, change or modify the surrounding characters,
  -- and more.
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },

  -- comments
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  -- Better text-objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
    end,
  },
  {
    'crusj/bookmarks.nvim',
    keys = {
      { "ma", function() require("bookmarks").add_bookmarks() end, desc = "Add" },
      { "md", function() require("bookmarks").delete_on_virt() end, desc = "Delete" },
      { "mm", function() require("bookmarks").toggle_bookmarks() end, desc = "show" },
      { "ms", function() require("bookmarks.list").show_desc() end, desc = "Show Desc" },
    },
    branch = 'main',
    dependencies = { 'nvim-web-devicons' },
    config = function()
        require("bookmarks").setup()
        require("telescope").load_extension("bookmarks")
    end
  },
  {
    "simrat39/symbols-outline.nvim",
    keys = {
      {"<leader>us", "<cmd>SymbolsOutline<CR>", desc = "Show Symbols"},
    },
    opts = {
      highlight_hovered_item = true,
	    show_guides = true,
	    auto_preview = false,
	    position = "right",
	    width = 40,
	    show_numbers = false,
	    show_relative_numbers = false,
	    show_symbol_details = true,
	    keymaps = { -- These keymaps can be a string or a table for multiple keys
	    	close = { "<Esc>", "q" },
	    	goto_location = "<Cr>",
	    	focus_location = "o",
	    	hover_symbol = "<C-space>",
	    	toggle_preview = "K",
	    	rename_symbol = "r",
	    	code_actions = "a",
	    },
	    lsp_blacklist = {},
	    symbol_blacklist = {},
	    symbols = {
	    	File = { icon = icons.documents.File, hl = "CmpItemKindFile" },
	    	Module = { icon = icons.kind.Module, hl = "CmpItemKindModule" },
	    	Namespace = { icon = icons.kind.Module, hl = "CmpItemKindModule" },
	    	Package = { icon = icons.kind.Module, hl = "CmpItemKindModule" },
	    	Class = { icon = icons.kind.Class, hl = "CmpItemKindClass" },
	    	Method = { icon = icons.kind.Method, hl = "CmpItemKindMethod" },
	    	Property = { icon = icons.kind.Property, hl = "CmpItemKindProperty" },
	    	Field = { icon = icons.kind.Field, hl = "CmpItemKindField" },
	    	Constructor = { icon = icons.kind.Constructor, hl = "CmpItemKindConstructor" },
	    	Enum = { icon = icons.kind.Enum, hl = "CmpItemKindEnum" },
	    	Interface = { icon = icons.kind.Interface, hl = "CmpItemKindInterface" },
	    	Function = { icon = icons.kind.Function, hl = "CmpItemKindFunction" },
	    	Variable = { icon = icons.kind.Variable, hl = "CmpItemKindVariable" },
	    	Constant = { icon = icons.kind.Constant, hl = "CmpItemKindConstant" },
	    	String = { icon = icons.type.String, hl = "TSString" },
	    	Number = { icon = icons.type.Number, hl = "TSNumber" },
	    	Boolean = { icon = icons.type.Boolean, hl = "TSBoolean" },
	    	Array = { icon = icons.type.Array, hl = "TSKeyword" },
	    	Object = { icon = icons.type.Object, hl = "TSKeyword" },
	    	Key = { icon = icons.kind.Keyword, hl = "CmpItemKeyword" },
	    	Null = { icon = "NULL", hl = "TSKeyword" },
	    	EnumMember = { icon = icons.kind.EnumMember, hl = "CmpItemKindEnumMember" },
	    	Struct = { icon = icons.kind.Struct, hl = "CmpItemKindStruct" },
	    	Event = { icon = icons.kind.Event, hl = "CmpItemKindEvent" },
	    	Operator = { icon = icons.kind.Operator, hl = "CmpItemKindOperator" },
	    	TypeParameter = { icon = icons.kind.TypeParameter, hl = "CmpItemKindTypeParameter" },
	    },
    },
  },
  {
    "folke/zen-mode.nvim",
    lazy = true,
    keys = {
       {"<leader>uz", function() require("zen-mode").toggle() end, desc = "ZenMode"},
    },
  },
}
