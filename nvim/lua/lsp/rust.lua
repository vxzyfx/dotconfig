local on_attach = function(client, bufnr)
  local handler = require("config.handler")
  local rt = require("rust-tools")
  local wk = require("which-key")
  wk.register({
    ["<leader>"] = { function() rt.code_action_group.code_action_group() end, "Rust Action" },
    d = {
      c = { function() rt.debuggables.debuggables() end, "Continue"},
    },
    r = {
      name = "rust",
      h = { function() rt.hover_actions.hover_actions() end, "Hover"},
      o = { function() rt.inlay_hints.set() end, "Set inlay hints"},
      p = { function() rt.inlay_hints.unset() end, "Unset inlay hints"},
      e = { function() rt.inlay_hints.enable() end, "Enable inlay hints"},
      d = { function() rt.inlay_hints.disable() end, "Disable inlay hints"},
      r = { function() rt.runnables.runnables() end, "Runable"},
      m = { function() rt.expand_macro.expand_macro() end, "ExpandMacro"},
      j = { function() rt.move_item.move_item(false) end, "Move down"},
      k = { function() rt.move_item.move_item(true) end, "Move down"},
      t = { function() rt.open_cargo_toml.open_cargo_toml() end, "Open Toml"},
    },
  }, { buffer = bufnr, prefix = "<leader>"})
  handler.on_attach(client, bufnr)
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = true,
      },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
      end
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = function()
      return {
        dap = {
          adapter = require("config.dap").codelldb,
        },
        tools = {
	        -- executor = require("rust-tools.executors").termopen,
	        reload_workspace_from_cargo_toml = true,
          inlay_hints = {
            only_current_line = false,
            auto = true,
            only_current_line_autocmd = "CursorHold",
            show_parameter_hints = true,
            show_variable_name = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
          hover_actions = {
            auto_focus = false,
            border = "rounded",
            width = 60,
          },
        },
        server = {
          on_attach = on_attach,
          cmd = {"rustup", "run", "stable", "rust-analyzer"},
        },
      }
    end
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = {
      adapters = {
        ["neotest-rust"] = {},
      },
    },
  },
}
