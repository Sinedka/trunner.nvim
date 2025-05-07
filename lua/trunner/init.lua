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
  if ft == "NvTerm_sp" then
    local prev_buf = vim.fn.bufnr "#" -- получаем номер предыдущего буфера ('#')
    print(prev_buf)
    if prev_buf ~= -1 then -- проверяем, что буфер существует
      ft = vim.bo[prev_buf].filetype
      path = vim.fn.fnamemodify(vim.fn.bufname "#", ":p")
    end
  end

  local cmd = opts.commands[ft]

  if not cmd then
    print("No command for filetype: " .. ft)
    return
  end

  cmd = utils.replaceVars(cmd, path)
  require("nvchad.term").runner { pos = opts.term.pos, id = opts.term.id, cmd = cmd }
end

return M
