local extra = {
  {
    description = "coding net cli",
    fileMatch =  { ".coding-ci.yml" },
    name = "conding.yml",
    url = "https://ci.coding.net/docs/conf-schema.json",
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    opts = function(_, opts)
      local schemastore = require("schemastore");
      return {
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              hover = true,
              completion = true,
              validate = true,
              schemas = schemastore.yaml.schemas {
                extra = extra,
              },
              schemaStore = {
                enable = false,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              format = {
                enable = true,
              },
              schemas = schemastore.json.schemas {
                extra = extra,
              },
              validate = { enable = true },
            },
          },
        }
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "yaml" })
      end
    end,
  },
}
