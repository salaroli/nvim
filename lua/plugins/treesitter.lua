-- nvim-treesitter `main` branch (rewrite). Required for Neovim 0.12+ —
-- the legacy `master` branch was archived and crashes on 0.12 with
-- "attempt to call method 'range' (a nil value)" inside query_predicates.lua.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ensure_installed = { "lua", "vim", "vimdoc", "query" }

    require("nvim-treesitter").install(ensure_installed)

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
