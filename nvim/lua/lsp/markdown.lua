return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.marksman = {}
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
  },
  {
    "ellisonleao/glow.nvim", 
    config = true, 
    cmd = "Glow"
  }
}
