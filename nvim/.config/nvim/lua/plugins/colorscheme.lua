return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false, -- éste sigue siendo el activo al arrancar
    priority = 1000,
    opts = { style = "dark", transparent = false },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true, -- no carga al inicio, solo cuando lo eliges
    opts = {
      theme = "wave", -- variantes: "wave" (default), "dragon" (más oscuro/contraste), "lotus" (claro)
      transparent = false,
    },
  },

  {
    "navarasu/onedark.nvim",
    version = "v0.1.0", -- Pin to legacy version
    lazy = true,
    config = function()
      require("onedark").setup({
        style = "warmer", --dark, darker, cool, deep, warm, warmer
      })
      require("onedark").load()
    end,
  },

  { "LazyVim/LazyVim", opts = { colorscheme = "vscode" } },
}
