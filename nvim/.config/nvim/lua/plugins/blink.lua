-- Autocompletado (blink.cmp, el de LazyVim por defecto)
return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      -- Al aceptar una sugerencia con el cursor en mitad de una palabra,
      -- sustituir la palabra entera (no solo lo que hay antes del cursor).
      -- Evita cosas como SEVEN_SEGMENTS_H_H.
      keyword = { range = "full" },
    },
  },
}
