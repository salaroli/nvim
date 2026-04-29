return {
  "numToStr/Comment.nvim",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    -- Estilo VSCode: Ctrl+/ (e Ctrl+_, fallback de alguns terminais)
    {
      "<C-/>",
      function() require("Comment.api").toggle.linewise.current() end,
      mode = "n",
      desc = "Comentar linha",
    },
    {
      "<C-_>",
      function() require("Comment.api").toggle.linewise.current() end,
      mode = "n",
      desc = "Comentar linha",
    },
    { "<C-/>", "<Esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", mode = "v", desc = "Comentar seleção" },
    { "<C-_>", "<Esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", mode = "v", desc = "Comentar seleção" },
    -- Estilo VSCode: Shift+Alt+A (comentário em bloco)
    {
      "<S-A-a>",
      function() require("Comment.api").toggle.blockwise.current() end,
      mode = "n",
      desc = "Comentar em bloco",
    },
    { "<S-A-a>", "<Esc><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<CR>", mode = "v", desc = "Comentar em bloco (seleção)" },
  },
  opts = {},
}
