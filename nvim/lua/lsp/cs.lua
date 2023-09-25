return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.csharp_ls = {
        on_attach = function(client, bufnr)
          require("config.handler").on_attach(client, bufnr)
        end,
      }
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c_sharp" })
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "Issafalcon/neotest-dotnet",
    },
    opts = {
      adapters = {
        ["neotest-dotnet"] = {},
      },
    },
  },
}
