---@module "lazy"
---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "saghen/blink.lib",
      "rafamadriz/friendly-snippets",
    },
    build = function()
      ---@diagnostic disable-next-line
      require("blink.cmp").build():pwait()
    end,
    opts = function()
      ---@module "blink.cmp"
      ---@type blink.cmp.Config
      return {
        appearance = {
          nerd_font_variant = "normal",
          use_nvim_cmp_as_default = false,
        },
        cmdline = {
          enabled = true,
          keymap = {
            preset = "cmdline",
            ["<Right>"] = false,
            ["<Left>"] = false,
          },
          completion = {
            list = { selection = { preselect = false } },
            menu = {
              auto_show = function()
                return vim.fn.getcmdtype() == ":"
              end,
            },
            ghost_text = { enabled = true },
          },
        },
        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = { border = "single" },
          },
          menu = {
            scrollbar = false,
            border = "none",
            draw = {
              padding = 0,
              treesitter = { "lsp" },
              columns = { { "kind_icon" }, { "label" }, { "kind" } },
              components = {
                kind = { highlight = "comment" },
                kind_icon = {
                  text = function(ctx)
                    return " " .. require("mini.icons").get("lsp", ctx.kind) .. " "
                  end,
                },
              },
            },
          },
          ghost_text = {
            enabled = true,
          },
        },
        keymap = {
          preset = "super-tab",
          ["<C-y>"] = { "select_and_accept" },
          ["<Tab>"] = {
            require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
            "fallback",
          },
        },
        signature = {
          enabled = true,
        },
        snippets = {
          preset = "default",
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            lua = { inherit_defaults = true, "lazydev" },
          },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100, -- show at a higher priority than lsp
            },
          },
        },
      }
    end,
  },
}
