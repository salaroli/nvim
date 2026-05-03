return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    -- Estilo Leader (vim-like)
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar arquivos" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar no projeto (grep)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Arquivos recentes" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Símbolos do documento" },
    -- Estilo VSCode
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Quick Open (arquivos)" },
    { "<C-S-p>", "<cmd>Telescope commands<cr>", desc = "Command Palette" },
    { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "Find in Files" },
    { "<C-S-o>", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Go to Symbol in File" },
    { "<C-t>", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Go to Symbol in Workspace" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        layout_config = { horizontal = { preview_width = 0.55 } },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
}
