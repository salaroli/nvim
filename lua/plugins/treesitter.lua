-- nvim-treesitter `main` branch (rewrite). Required for Neovim 0.12+ —
-- the legacy `master` branch was archived and crashes on 0.12 with
-- "attempt to call method 'range' (a nil value)" inside query_predicates.lua.
--
-- Some parsers (e.g. vimdoc) have no pre-built binaries and must be compiled
-- from source. This requires the `tree-sitter` CLI to be in PATH.
-- Install on Arch Linux:  sudo pacman -S tree-sitter
-- Install via cargo:      cargo install tree-sitter-cli
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ensure_installed = { "lua", "vim", "vimdoc", "query" }

    if vim.fn.executable("tree-sitter") == 0 then
      vim.notify(
        "tree-sitter CLI not found — some parsers (e.g. vimdoc) cannot be compiled.\n"
          .. "Arch Linux:  sudo pacman -S tree-sitter\n"
          .. "Via cargo:   cargo install tree-sitter-cli",
        vim.log.levels.WARN,
        { title = "nvim-treesitter" }
      )
    end

    vim.schedule(function()
      require("nvim-treesitter").install(ensure_installed)
    end)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end

        if not pcall(vim.treesitter.language.add, lang) then
          require("nvim-treesitter").install({ lang })
          return
        end

        pcall(vim.treesitter.start, args.buf, lang)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
