return {
  -- Tema por defecto: Catppuccin Mocha
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
    },
  },

  -- Resto de temas: lazy, solo se cargan al elegirlos (<leader>uC)
  {
    "Mofiqul/vscode.nvim",
    lazy = true,
    opts = { style = "dark", transparent = false },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      theme = "wave", -- "wave", "dragon" (más contraste), "lotus" (claro)
      transparent = false,
    },
  },

  {
    "navarasu/onedark.nvim",
    version = "v0.1.0", -- Pin to legacy version
    lazy = true,
    opts = {
      style = "warmer",
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer" },
      toggle_style_key = "<leader>ts",
    },
  },

  {
    "ribru17/bamboo.nvim",
    lazy = true,
    opts = {},
  },

  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = true,
    opts = {},
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {},
  },

  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },
}
