local o = require "trunner.options"
local utils = require "trunner.utils"
local M = {}

M.setup = function(opts)
  o.set(opts)
end

-- M.run() {
--   require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm", cmd = "zfetch" },
-- }

function M.run_current_file()
  local opts = o.get()
  local path = vim.fn.expand "%:p"
  local ft = vim.bo.filetype
  local cmd = opts.commands[ft]

  if not cmd then
    print("No command for filetype: " .. ft)
    return
  end

  cmd = utils.replaceVars(cmd, path)
  require("nvchad.term").runner { pos = opts.term.pos, id = opts.term.id, cmd = cmd }
end

return M
