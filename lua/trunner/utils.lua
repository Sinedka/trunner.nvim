local M = {}

M.replaceVars = function(command, path)
  print(path:match("^(.*)%.*"));
  command = command:gsub("$fileNameWithoutExt", path:match("^(.*)%.*"))
  command = command:gsub("$fileName", path)
  return command
end

return M
