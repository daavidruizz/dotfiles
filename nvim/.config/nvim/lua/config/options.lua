-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"

-- Indentación de 4 espacios al escribir (LazyVim trae 2 por defecto),
-- igual que el IndentWidth: 4 de clang-format
vim.opt.tabstop = 4 -- un tab se ve como 4 columnas
vim.opt.shiftwidth = 4 -- tamaño de cada nivel de indentación (Enter, >>, <<)
vim.opt.softtabstop = 4 -- Tab/Backspace en modo insertar avanzan/borran 4
vim.opt.expandtab = true -- insertar espacios, no caracteres tab
