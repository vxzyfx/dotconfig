local util = require("lspconfig.util");
local handler = require("config.handler")
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      volar = {
	      on_attach = handler.on_attach,
      },
      tailwindcss = {},
      tsserver = {
	      on_attach = handler.on_attach,
        keys = {
          { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
          { "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
        },
        settings = {
          typescript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpaces = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
          },
          javascript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpaces = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
          },
          completions = {
            completeFunctionCalls = true,
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "vue", "css", "scss", "typescript", "tsx", "json" })
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local nls = require("null-ls")
        local ts = require("typescript.extensions.null-ls.code-actions")
        vim.list_extend(opts.sources, {
          ts,
          nls.builtins.code_actions.eslint,
          nls.builtins.formatting.eslint,
          nls.builtins.formatting.prettier,
          nls.builtins.diagnostics.eslint,
          nls.builtins.formatting.stylelint,
          nls.builtins.diagnostics.stylelint,
        })
      end
    end,
  },
  {
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    opts = {},
    event = "BufRead package.json",
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    },
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    opts = {},
  },
}
