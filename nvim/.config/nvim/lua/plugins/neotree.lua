-- Use Neo-tree instead of Snacks Explorer in LazyVim
return {

  -- 1. Disable Snacks Explorer
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
    },
  },

  -- 2. Enable Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,

        filesystem = {
          follow_current_file = true,
          use_libuv_file_watcher = true,

          filtered_items = {
            hide_dotfiles = false, -- ← mostrar archivos ocultos siempre
            hide_gitignored = false,
          },
        },
      })

      -- Keymap recomendado de LazyVim
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {
        desc = "Toggle Neo-tree",
      })
    end,
  },
}
