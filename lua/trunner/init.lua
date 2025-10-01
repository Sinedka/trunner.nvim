local o = require "trunner.options"
local utils = require "trunner.utils"
local M = {}

M.setup = function(opts)
  o.set(opts)
end

local function dap_run(filetype, binary, input_file)
  local dap = require('dap')
  local configs = dap.configurations[filetype]
  if not configs or #configs == 0 then
    vim.notify("Нет конфигураций для " .. filetype, vim.log.levels.ERROR)
    return
  end

  -- Берём первую конфигурацию и клонируем её
  local config = vim.deepcopy(configs[1])

  -- Указываем бинарник
  if binary then
    config.program = binary
  end

  -- Если есть входной файл — пробросим его как аргумент
  if input_file then
    config.args = { input_file }
  end

  dap.run(config)
end

local function run_commands_sequential_term(commands, func)
  local i = 1

  local function run_next()
    if i > #commands then
      if func then
        func()
      end
      print("Все команды выполнены")
      return
    end

    local cmd = commands[i]
    i = i + 1

    -- Создаём терминальный буфер
    vim.cmd("botright split | resize 15 | terminal")
    local bufnr = vim.api.nvim_get_current_buf()
    local term_job_id = vim.b.terminal_job_id

    -- Отправляем команду в терминал
    vim.fn.chansend(term_job_id, cmd .. "\n")

    -- Ждём окончания команды
    vim.api.nvim_create_autocmd("TermClose", {
      buffer = bufnr,
      once = true,
      callback = function(ev)
        -- Удаляем буфер, если команда завершилась успешно
        if ev.status == 0 then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
        run_next() -- запускаем следующую команду
      end
    })
  end

  run_next()
end
function M.run_current_Project(isDebug)
  local opts = o.get();
  local function file_in_project_root_exists(filename)
    local path = vim.fn.getcwd() .. "/" .. filename
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "file"
  end

  local function correct_project_type(project_type)
    for _, value in ipairs(project_type) do
      local f = true;
      for _, file in ipairs(value) do
        f = file_in_project_root_exists(file) and f;
      end
      if f then return true end
    end
    return false
  end



  for key, v in pairs(opts.dir_files) do
    local cmd;
    if correct_project_type(v) then
      if not (key == 'cmake' and opts.options.UseCmakeTools) then
        cmd = opts.commands[key].build;
        if not cmd then goto continue; end
      end

      run_in_term(cmd);
      if isDebug then
        if key == 'cmake' and opts.options.UseCmakeTools then
          vim.cmd('CmakeDebug')
        else
          run_in_term(opts.commands[key].debug)
        end
      else
        if key == 'cmake' and opts.options.UseCmakeTools then
          vim.cmd('CmakeBuild')
          vim.cmd('CmakeRun')
        else
          vim.schedule(function()
            local code1 = run_in_term(opts.commands[key].build)
            if code1 == 0 then
              vim.cmd("botright split | resize 15 | terminal bash -c '" .. opts.commands[key].run .. "; exec bash'")
            end
          end)
        end
      end
    end
    ::continue::
  end
end

function M.run_current_file(isDebug, test)
  local opts = o.get()
  local path = vim.fn.expand "%:p"
  local ft = vim.bo.filetype

  local testf
  if (test == -1) then
    testf = 0;
  else
    testf = path:match("(.+)%..+$") .. "_input" .. test .. ".txt"
  end

  local cmds = opts.commands[ft]

  if not cmds then
    return false;
  end

  if isDebug then
    vim.schedule(function()
      vim.notify("Привет из Neovim!", vim.log.levels.INFO)
      local cmd = utils.replaceVars(cmds.build_debug, path)
      run_commands_sequential_term({ cmd }, function()
        dap_run(ft, path, testf)
      end)
    end)
  else
    run_commands_sequential_term({ utils.replaceVars(cmds.build, path), utils.replaceVars(cmds.run, path) })
  end
end

return M
