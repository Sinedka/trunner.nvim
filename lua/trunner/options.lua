local options = {
  dir_files = {
    cmake = {
      { "CmakeLists.txt" },
    },
    gnumake = {
      { "GNUmakefile" },
      { "Makefile" },
      { "makefile" },
    }
  },

  commands = {
    gnumake = {
      run = "make run",
      build = "build",
      outfile = function()
        return vim.fn.input("Путь к исполняемому файлу: ", vim.fn.getcwd() .. "/", "file");
      end,
    },
    cpp = {
      run = "./$fileNameWithoutExt";
      build = "g++ $fileName -o $fileNameWithoutExt",
      build_debug = "g++ $fileName -o $fileNameWithoutExt -g";
      outfile = "$fileNameWithoutExt";
    },
    c = {
      run = "./$fileNameWithoutExt";
      build = "gcc $fileName -o $fileNameWithoutExt",
      build_debug = "gcc $fileName -o $fileNameWithoutExt -g ";
      outfile = "$fileNameWithoutExt";
    },
  },
  term = {
    pos = "sp",
    id = "htoggleTerm",
  },
  options = {
    UseCmakeTools = true,
  }
}

local M = {}

M.set = function(user_options)
  options = vim.tbl_deep_extend("force", options, user_options)
end

M.get = function()
  return options
end

return M
