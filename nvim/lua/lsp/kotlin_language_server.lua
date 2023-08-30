return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      kotlin_language_server = {},
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "kotlin" })
      end
    end,
  },
}
