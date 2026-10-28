-- Formato C/C++ con clang-format y un estilo global (Allman),
-- independiente de dónde esté el archivo (incluido el montaje sshfs)
return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "clang-format" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = { "--style={BasedOnStyle: LLVM, BreakBeforeBraces: Allman, IndentWidth: 4}" },
        },
      },
    },
  },
}
