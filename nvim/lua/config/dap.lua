local M = {};
local home = os.getenv("HOME");
M.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = home .. "/.tools/codelldb/extension/adapter/codelldb",
    args = {
      "--port",
      "${port}",
    },
  },
};

return M;
