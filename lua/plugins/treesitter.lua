-- nvim-treesitter `main` branch (rewrite). Required for Neovim 0.12+ —
-- the legacy `master` branch was archived and crashes on 0.12 with
-- "attempt to call method 'range' (a nil value)" inside query_predicates.lua.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ensure_installed = { "lua", "vim", "vimdoc", "query", "css", "scss" }

    require("nvim-treesitter").install(ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end

        local function start_hl(bufnr)
          if pcall(vim.treesitter.start, bufnr, lang) then
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end

        if not pcall(vim.treesitter.language.add, lang) then
          local bufnr = args.buf
          require("nvim-treesitter").install({ lang })
          -- Parser install is async; poll until it's ready then apply highlight.
          local tries = 0
          local function wait_and_hl()
            tries = tries + 1
            if not vim.api.nvim_buf_is_valid(bufnr) then return end
            if pcall(vim.treesitter.language.add, lang) then
              start_hl(bufnr)
            elseif tries < 40 then
              vim.defer_fn(wait_and_hl, 500)
            end
          end
          vim.defer_fn(wait_and_hl, 500)
          return
        end

        start_hl(args.buf)
      end,
    })
  end,
}
