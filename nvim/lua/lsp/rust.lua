local on_attach = function(client, bufnr)
  local handler = require("config.handler")
  local null_ls = require("null-ls")
  local rt = require("rust-tools")
  local wk = require("which-key")
  local unwrap = {
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { "rust" },
    generator = {
      fn = function(params)
        local diagnostics = {}
        for i, line in ipairs(params.content) do
          local col, end_col = line:find "unwrap()"
          if col and end_col then
            table.insert(diagnostics, {
              row = i,
              col = col,
              end_col = end_col,
              source = "unwrap",
              message = "hey " .. os.getenv("USER") .. ", don't forget to handle this" ,
              severity = 2,
            })
          end
        end
       return diagnostics
      end,
    },
  }
  null_ls.register(unwrap)
  wk.register({
    ["<leader>"] = { rt.code_action_group.code_action_group, "Rust Action" },
    d = {
      d = { rt.debuggables.debuggables, "Debug"},
    },
    r = {
      name = "rust",
      h = { rt.hover_actions.hover_actions, "Hover"},
      o = { rt.inlay_hints.set, "Set inlay hints"},
      p = { rt.inlay_hints.unset, "Unset inlay hints"},
      e = { rt.inlay_hints.enable, "Enable inlay hints"},
      d = { rt.inlay_hints.disable, "Disable inlay hints"},
      r = { rt.runnables.runnables, "Runable"},
      m = { rt.expand_macro.expand_macro, "ExpandMacro"},
      j = { function() rt.move_item.move_item(false) end, "Move down"},
      k = { function() rt.move_item.move_item(true) end, "Move down"},
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
          adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_lldb",
          },
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
