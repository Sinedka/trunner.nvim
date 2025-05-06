vim.api.nvim_create_user_command("RunProgram", function()
  require("trunner").run_current_file()
end, {
  desc = "Run the current file using the appropriate command for its type",
  nargs = 0,
})

-- Helper command for quick access to plugin documentation
vim.api.nvim_create_user_command("TrunnerHelp", function()
  vim.cmd("help trunner.txt")
end, {
  desc = "Open trunner plugin documentation",
  nargs = 0,
})
