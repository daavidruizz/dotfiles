-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- CONFIGURACIÓN CLIPBOARD
vim.opt.clipboard = "unnamedplus" -- Usar clipboard del sistema

-- KEYMAPS PARA COPY/PASTE
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
vim.keymap.set("n", "<C-v>", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste in insert mode" })

-- Configuración básica
vim.opt.number = true
vim.opt.mouse = "a"
