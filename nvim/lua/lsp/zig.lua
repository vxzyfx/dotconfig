return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.zls = {}
    end
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.configurations.zig = {
        {
          type = "gdb",
          request = "launch",
          name = "Launch file",
          program = function()
            local path = string.match(vim.fn.getcwd(), ".*/(.*)$");
            if path == nil then
              path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file");
            else
              path = vim.fn.getcwd() .. "/zig-out/bin/" .. path;
            end
            return path
          end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "gdb",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "zig" })
      end
    end,
  },
}
