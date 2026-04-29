return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        -- Frontend / Web
        "ts_ls",
        "eslint",
        "html",
        "cssls",
        "tailwindcss",
        "jsonls",
        "volar",
        "emmet_language_server",
        -- Embedded / Sistemas
        "clangd",
        "rust_analyzer",
        "cmake",
        "pyright",
        -- Lua (config)
        "lua_ls",
      },
      automatic_installation = true,
    },
  },
}
