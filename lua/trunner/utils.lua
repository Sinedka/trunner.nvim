local M = {}

M.replaceVars = function(command, path)
  command = command:gsub("$fileNameWithoutExt", vim.fn.fnamemodify(path, ":r"))
  command = command:gsub("$fileName", path)

  return command
end

return M
