return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local lspconfig = require("lspconfig")
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
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gr", vim.lsp.buf.references, "Go to references")
        map("gi", vim.lsp.buf.implementation, "Go to implementation")
        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Diagnóstico anterior")
        map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Próximo diagnóstico")
      end,
    })

    local servers = {
      -- Frontend / Web
      ts_ls = {},
      eslint = {},
      html = {},
      cssls = {},
      tailwindcss = {},
      jsonls = {},
      volar = {},
      emmet_language_server = {},
      -- Embedded / Sistemas (rust_analyzer é gerenciado pelo rustaceanvim)
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
      config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
      lspconfig[server].setup(config)
    end
  end,
}
