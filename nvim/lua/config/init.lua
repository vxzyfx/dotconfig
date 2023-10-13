require("config.options")
require("config.autocommands")
vim.g.tabby_accept_binding = "<C-j>"
vim.g.tabby_dismiss_binding = "<C-k>"

local tabby_server_url = os.getenv("TABBY_SERVER_URL")
if tabby_server_url then
  vim.g.tabby_server_url = tabby_server_url
end
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  install = { colorscheme = { "tokyonight" } },
  spec = {
    { import = "plugins"},
    { import = "lsp"},
  },
})

local status_ok, colorscheme = pcall(require, "tokyonight")
if status_ok then
  colorscheme.load()
end

