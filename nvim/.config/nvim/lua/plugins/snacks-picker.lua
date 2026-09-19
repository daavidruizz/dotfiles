-- Mostrar dotfiles en el picker de archivos (Espacio Espacio)
-- Este repo vive casi entero bajo carpetas ocultas (hypr/.config/...,
-- bash/.bashrc, etc.), así que sin esto fd las descarta por completo.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
      },
    },
  },
}
