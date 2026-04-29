return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  ft = { "rust" },
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        hover_actions = { auto_focus = true },
        float_win_config = { border = "rounded" },
      },
      server = {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        on_attach = function(_, bufnr)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Rust: " .. desc })
          end
          map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Runnables")
          map("<leader>rt", function() vim.cmd.RustLsp("testables") end, "Testables")
          map("<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "Debuggables")
          map("<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
          map("<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
          map("<leader>rp", function() vim.cmd.RustLsp("parentModule") end, "Parent module")
          map("<leader>re", function() vim.cmd.RustLsp("explainError") end, "Explain error")
          map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover actions")
          map("<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Code action")
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true, loadOutDirsFromCheck = true, runBuildScripts = true },
            checkOnSave = { command = "clippy", extraArgs = { "--no-deps" } },
            procMacro = { enable = true },
            inlayHints = {
              bindingModeHints = { enable = false },
              chainingHints = { enable = true },
              closingBraceHints = { minLines = 25 },
              closureReturnTypeHints = { enable = "never" },
              lifetimeElisionHints = { enable = "never" },
              parameterHints = { enable = true },
              typeHints = { enable = true },
            },
          },
        },
      },
      dap = {},
    }
  end,
}
