return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSUpdateSync" },
  opts = {
    -- Lista mínima: só o essencial para editar a própria config.
    -- O resto é instalado automaticamente quando você abre um arquivo
    -- do filetype correspondente (auto_install).
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "query",
    },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
