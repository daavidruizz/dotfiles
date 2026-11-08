return {
  "uga-rosa/ccc.nvim",
  -- Esto asegura que el plugin se cargue automáticamente al abrir cualquier archivo
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ccc = require("ccc")

    ccc.setup({
      highlighter = {
        auto_enable = true, -- Resalta los colores automáticamente
        lsp = true, -- Soporte para colores detectados por LSP
      },
    })

    -- Atajo de teclado: Espacio + c + p abre el selector de color interactivo
    -- (no usar <leader>c a secas: es el prefijo del grupo "code" de LazyVim)
    vim.keymap.set("n", "<leader>cp", "<cmd>CccPick<cr>", { desc = "Selector de Color (CCC)" })
  end,
}
