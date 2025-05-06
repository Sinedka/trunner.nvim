# trunner.nvim

A simple Neovim plugin that simplifies running source code directly from the editor. Only works with NvChad to display results in the terminal.

## Features

- Run the current file with the `:RunProgram` command
- Support for different programming languages (C and C++ pre-configured)
- Easy configuration of commands for each file type
- Use variables in run commands

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'Sinedka/trunner.nvim',
  cmd = { "RunProgram" }
}
```

## Configuration

```lua
require('trunner').setup({
  commands = {
    -- Configuration commands for different file types
    cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
    c = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
    python = "python3 $file",
    -- Add your settings for other languages
  },
  term = {
    pos = "sp", -- Terminal position: sp(split), vs(vsplit), float
    id = "htoggleTerm", -- Terminal ID for NvChad
  },
})
```

## Available Variables

When configuring run commands, you can use the following variables:

- `$fileNameWithoutExt` - filename without extension
- `$fileName` - full filename with extension
- `$file` - full path to the file
- `$dir` - directory containing the file

## Usage

After installing and configuring the plugin, simply open a file of the desired type and run:

```
:RunProgram
```

The plugin will automatically select the correct command to run based on the file type and display the result in the terminal.

## License

MIT
