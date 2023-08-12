vim.api.nvim_create_autocmd({"BufReadPost"}, {
  pattern = {""},
  callback = function()
    local line = vim.fn.line
    if (line("'\"") > 0 and line ("'\"") <= line("$"))
    then
      vim.fn.execute("normal! g'\"")
    end
  end
})

