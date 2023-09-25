return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.kotlin_language_server = {
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
        vim.list_extend(opts.ensure_installed, { "kotlin" })
      end
    end,
  },
  {
    "Mgenuit/nvim-dap-kotlin",
    config = true,
  },
}
