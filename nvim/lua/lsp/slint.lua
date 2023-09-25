return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.slint_lsp = {}
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "slint" })
      end
    end,
  },
}
