return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      mode = "buffers",
      separator_style = "slant",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = " ", warning = " " }
        local ret = (diag.error and icons.error .. diag.error .. " " or "")
          .. (diag.warning and icons.warning .. diag.warning or "")
        return vim.trim(ret)
      end,
      show_buffer_close_icons = true,
      show_close_icon = false,
      always_show_bufferline = true,
    },
  },
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer anterior" },
    { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Próximo buffer" },
    { "<leader>bd", "<cmd>bdelete<CR>", desc = "Fechar buffer" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Fixar buffer" },
  },
}
