local M = {}

M.replaceVars = function(command, path)
  path = path:gsub(" ", "\\ ")
  command = command:gsub("$fileNameWithoutExt", vim.fn.fnamemodify(path, ":r"))
  command = command:gsub("$fileName", path)

  return command
end

return M
