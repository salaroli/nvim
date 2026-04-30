return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    vim.diagnostic.config({
      virtual_text = { prefix = "●" },
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = true,
      update_in_insert = false,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        -- Estilo Leader (vim-like)
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gr", vim.lsp.buf.references, "Go to references")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Diagnóstico anterior")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Próximo diagnóstico")
        -- Estilo VSCode
        map("n", "<F12>", vim.lsp.buf.definition, "Go to Definition")
        map("n", "<S-F12>", vim.lsp.buf.references, "Find All References")
        map("n", "<C-F12>", vim.lsp.buf.implementation, "Go to Implementation")
        map("n", "<F2>", vim.lsp.buf.rename, "Rename Symbol")
        map({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, "Quick Fix / Code Action")
        map("n", "<C-h>", vim.lsp.buf.hover, "Show Hover")
      end,
    })

    -- Default capabilities aplicadas a todos os servidores via vim.lsp.config('*', ...)
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- Configs por servidor (mescladas com os defaults vindos de nvim-lspconfig)
    -- rust_analyzer é gerenciado pelo rustaceanvim, por isso não está aqui.
    local servers = {
      -- Frontend / Web
      ts_ls = {},
      eslint = {},
      html = {},
      cssls = {},
      tailwindcss = {},
      jsonls = {},
      vue_ls = {},
      emmet_language_server = {},
      -- Embedded / Sistemas
      clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
      },
      cmake = {},
      -- Linux / scripting
      bashls = {},
      pyright = {},
      ruff = {},
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      },
      marksman = {},
      taplo = {},
      yamlls = {},
      dockerls = {},
    }

    for server, config in pairs(servers) do
      vim.lsp.config(server, config)
    end
    -- mason-lspconfig.nvim cuida de chamar vim.lsp.enable() para tudo que
    -- estiver em ensure_installed (automatic_enable é default em v2).
  end,
}
