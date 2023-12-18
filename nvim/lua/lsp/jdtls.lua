local jdt_path = vim.fn.stdpath("data") .. "/tools/jdt"
local jdt_jar = jdt_path .. "/plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar"
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "java" })
      end
    end,
  },
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   config = function()
  --     local config = {
  --       cmd = {
  --         'java', -- or '/path/to/java17_or_newer/bin/java'
  --         '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  --         '-Dosgi.bundles.defaultStartLevel=4',
  --         '-Declipse.product=org.eclipse.jdt.ls.core.product',
  --         '-Dlog.protocol=true',
  --         '-Dlog.level=ALL',
  --         '-Xmx1g',
  --         '--add-modules=ALL-SYSTEM',
  --         '-jar', jdt_jar,
  --         '-configuration', jdt_path .. "/config_linux",
  --         '-data', '.cache/jdtls'
  --       },
  --       root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'build.gradle', 'build.gradle.kts'}),
  --       settings = {
  --         java = {
  --         }
  --       },
  --       init_options = {
  --         bundles = {}
  --       },
  --     }
  --     require('jdtls').start_or_attach(config)
  --   end,
  -- },
}
