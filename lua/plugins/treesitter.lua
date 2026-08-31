---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "LazyFile", "VeryLazy" },
    build = function()
      require("nvim-treesitter").update(nil, { summary = true })
    end,
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "toml",
        "vim",
        "vimdoc",
      },
    },
    config = function(_, opts)
      local ts = require "nvim-treesitter"

      local _installed = nil ---@type table<string,boolean>?
      local _queries = {} ---@type table<string,boolean>

      local function get_installed(update)
        if update then
          _installed, _queries = {}, {}
          for _, lang in ipairs(ts.get_installed "parsers") do
            _installed[lang] = true
          end
        end
        return _installed or {}
      end

      local function have_query(lang, query)
        local key = lang .. ":" .. query
        if _queries[key] == nil then
          _queries[key] = vim.treesitter.query.get(lang, query) ~= nil
        end
        return _queries[key]
      end

      ts.setup()
      get_installed(true)

      local install = vim.tbl_filter(function(n)
        local lang = vim.treesitter.language.get_lang(n)
        if lang == nil or get_installed()[lang] == nil then
          return true
        end
        return false
      end, opts.ensure_installed or {})
      if #install > 0 then
        ts.install(install, { summary = true }):await(function()
          get_installed(true)
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if lang == nil or get_installed()[lang] == nil then
            return
          end

          if have_query(lang, "highlights") then
            vim.treesitter.start(event.buf)
          end

          if have_query(lang, "indents") then
            vim.bo[event.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
          end

          if have_query(lang, "folds") then
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt_local.foldmethod = "expr"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    ---@module "treesitter-context"
    ---@type TSContext.UserConfig
    opts = { mode = "cursor", max_lines = 3 },
  },
}
