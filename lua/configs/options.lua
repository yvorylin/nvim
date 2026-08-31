local g = vim.g
local opt = vim.opt

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
g.mapleader = " "
g.maplocalleader = "\\"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Sync with system clipboard
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
-- Enable highlighting of the current line
opt.cursorline = true
-- Enable highlighting of the current line number
opt.cursorlineopt = "number"
-- Use spaces instead of tabs
opt.expandtab = true

opt.foldlevel = 99

opt.foldmethod = "expr"

opt.foldtext = ""

-- Ignore case
opt.ignorecase = true
-- Global statusline
opt.laststatus = 3
-- Print line number
opt.number = true
-- Lines of context
opt.scrolloff = 4
-- Size of an indent
opt.shiftwidth = 2
-- Always show the tabline
opt.showtabline = 2
-- Columns of context
opt.sidescrolloff = 8
-- Always show the signcolumn
opt.signcolumn = "yes"
-- Don't ignore case with capitals
opt.smartcase = true
-- Insert indents automatically
opt.smartindent = true
-- Number of spaces tabs count for
opt.tabstop = 2
-- True color support
opt.termguicolors = true
-- Disable line wrap
opt.wrap = false
