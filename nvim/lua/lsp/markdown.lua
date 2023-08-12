return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      marksman = {},
    },
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
