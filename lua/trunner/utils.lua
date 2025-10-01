local M = {}

M.replaceVars = function(command, path)
  local lastdot = path:match(".*()%.") -- индекс последней точки
  local result = path:sub(1, lastdot - 1)
  print(result)                     --> example.text

  print(path:match("^(.*)%.*"));
  command = command:gsub("$fileNameWithoutExt", result)
  command = command:gsub("$fileName", path)
  return command
end

return M
