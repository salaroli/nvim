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
        "vue_ls",
        "emmet_language_server",
        -- Embedded / Sistemas
        "clangd",
        -- Linguagens "clássicas" do Linux
        "bashls",
        "lua_ls",
        "pyright",
        "ruff",
        "marksman",
        "taplo",
        "yamlls",
        "dockerls",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "prettierd",
        "prettier",
        "shfmt",
        "clang-format",
        "cmakelang",
        -- Linters
        "shellcheck",
        -- Debug (Rust embedded / C / C++)
        "codelldb",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}
