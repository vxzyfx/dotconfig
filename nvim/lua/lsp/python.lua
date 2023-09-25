return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },
  {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.pyright = {
      on_attach = function(client, bufnr)
        require("config.handler").on_attach(client, bufnr)
      end,
    }
    opts.ruff_lsp = {}
    end
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class" },
      },
      config = function()
        require("dap-python").setup("python")
      end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = function()
      local anaconda_base_path = nil;
      local anaconda_envs_path = nil;
      if vim.loop.os_uname().sysname == "Darwin" then
        anaconda_base_path = "/opt/homebrew/Caskroom/miniconda/base";
        anaconda_envs_path = "/opt/homebrew/Caskroom/miniconda/base/envs";
      end
      return {
        dap_enabled = true,
        anaconda_base_path = anaconda_base_path,
        anaconda_envs_path = anaconda_envs_path,
      }
    end,
    keys = { { "<leader>cv", "<CMD>:VenvSelect<CR>", desc = "Select VirtualEnv" } },
  },
}
