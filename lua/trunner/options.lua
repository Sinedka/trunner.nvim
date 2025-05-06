local options = {
  commands = {
    cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
    c = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
  },
  term = {
    pos = "sp",
    id = "htoggleTerm",
  },
}

local M = {}

M.set = function(user_options)
  options = vim.tbl_deep_extend("force", options, user_options)
end

M.get = function()
  return options
end

return M
