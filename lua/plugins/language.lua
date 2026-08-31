---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = true,
        severity_sort = true,
        float = { border = "single" },
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅙",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "󰋼",
            [vim.diagnostic.severity.HINT] = "󰌵",
          },
        },
      },
      ---@type table<string, vim.lsp.Config>
      providers = {
        ["*"] = {
          before_init = function(params, _)
            params.locale = "zh-cn"
          end,
          on_attach = function(client, bufnr)
            if client:supports_method("textDocument/inlayHint", bufnr) then
              if
                vim.api.nvim_buf_is_valid(bufnr)
                and vim.bo[bufnr].buftype == ""
                and not vim.tbl_contains({ "vue" }, vim.bo[bufnr].filetype)
              then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              end
            end

            if client:supports_method("textDocument/foldingRange", bufnr) then
              vim.opt_local.foldmethod = "expr"
              vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
            end

            -- TODO: add lsp keymap
          end,
        },
        ---@type lspconfig.settings.lua_ls
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
      for name, options in pairs(opts.providers) do
        vim.lsp.config(name, options)

        if name ~= "*" then
          vim.lsp.enable(name)
        end
      end
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    ---@module "lazydev"
    ---@type lazydev.Config
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
      },
    },
  },
}
