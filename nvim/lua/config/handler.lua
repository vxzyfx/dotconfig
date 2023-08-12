local M = {}

local function attach_navic(client, bufnr)
  vim.g.navic_silence = true
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end
  navic.attach(client, bufnr)
end

local function attach_lsp_signature(client, bufnr)
  local status_ok, signature = pcall(require, "lsp_signature")
  if not status_ok then
    return
  end
  signature.on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    }, bufnr)
end

local function lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, prefix = "<leader>"}
  local wk = require("which-key")

  wk.register({
--     ["<leader>"] = { function() vim.lsp.buf.code_action({ filter = function(a) return a.isPreferred end, apply = true }) end, "Aciton"},
    ["<CR>"] = { function() vim.diagnostic.goto_next({ border = "rounded" }) end, "Goto diag"},
    l = {
      name = "lsp",
      l = {"<cmd>Telescope lsp_definitions<CR>", "Go define"},
      d = {"<cmd>Telescope lsp_declarations<CR>", "Go declar"},
      k = { function() vim.lsp.buf.hover() end, "Show hover"},
      I = { "<cmd>Telescope lsp_implementations<CR>", "Go Impl"},
      r = { "<cmd>Telescope lsp_references<CR>", "Go refer"},
      i = { function() vim.diagnostic.open_float() end, "Open float"},
      s = { function() vim.lsp.buf.signature_help() end, "Show sign"},
      f = { function() vim.lsp.buf.format({ async = true }) end, "Format"},
      n = { function() vim.lsp.buf.rename() end, "Rename"},
      t = { function() vim.lsp.buf.type_definition() end, "Type define"},
    },
  }, opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  attach_navic(client, bufnr)
  -- attach_lsp_signature(client, bufnr)
end

return M
