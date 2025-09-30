vim.api.nvim_create_user_command("RunProgram", function()
  require("trunner").run_current_file(false, -1)
end, {
  desc = "Run the current file using the appropriate command for its type",
  nargs = 1,
})

vim.api.nvim_create_user_command(
  "RunDebug",
  function(opts)
    if opts.args == "no_tests" then
      require("trunner").run_current_file(true, -1)
    else
      require("trunner").run_current_file(true, opts)
    end
  end,
  { nargs = "?", complete = function() return { "no_tests"} end }
)
