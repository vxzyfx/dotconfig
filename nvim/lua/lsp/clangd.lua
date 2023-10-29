local on_attach = function(client, bufnr)
  local handler = require("config.handler")
  local wk = require("which-key")
  wk.register({
    r = {
      name = "cmake",
      b = { "<cmd>CMakeBuild<CR>", "Build"},
      r = { "<cmd>CMakeRun<CR>", "Runable"},
      c = { "<cmd>CMakeClose<CR>", "Close"},
      w = { "<cmd>CMakeQuickBuild<CR>", "Quick Build"},
      s = { "<cmd>CMakeQuickRun<CR>", "Quick Run"},
      d = { "<cmd>CMakeQuickDebug<CR>", "Quick Debug"},
    },
  }, { buffer = bufnr, prefix = "<leader>"})
  handler.on_attach(client, bufnr)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c", "cpp" })
      end
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      extensions = {
        inlay_hints = {
          inline = false,
        },
        ast = {
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.clangd = {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
        end,
        root_dir = function(...)
          -- using a root .clang-format or .clang-tidy file messes up projects, so remove them
          return require("lspconfig.util").root_pattern(
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac",
            ".git"
          )(...)
        end,
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
	    }
    end
  },

  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap");
      local gdbcmd = vim.fn.getcwd() .. "/.gdbcmd";
      local args = { "-i", "dap" };
      local _, err = io.open(gdbcmd, "r");
      if not err then
        vim.list_extend(args, { "-x", gdbcmd });
      end
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = args,
      }
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "gdb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
          },
          {
            type = "gdb",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "asm" },
    opts = {
      cmake_dap_configuration = { -- debug settings for cmake
        name = "cpp",
        type = "gdb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
      },
    },
  }
}
