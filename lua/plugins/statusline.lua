---@module "lazy"
---@type LazySpec
return {
  {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    opts = function(_, opts)
      opts.statusline = {
        {
          static = {
            modes = {
              ["n"] = { "NORMAL", "Normal" },
              ["no"] = { "NORMAL (no)", "Normal" },
              ["nov"] = { "NORMAL (nov)", "Normal" },
              ["noV"] = { "NORMAL (noV)", "Normal" },
              ["noCTRL-V"] = { "NORMAL", "Normal" },
              ["niI"] = { "NORMAL i", "Normal" },
              ["niR"] = { "NORMAL r", "Normal" },
              ["niV"] = { "NORMAL v", "Normal" },
              ["nt"] = { "NTERMINAL", "NTerminal" },
              ["ntT"] = { "NTERMINAL (ntT)", "NTerminal" },

              ["v"] = { "VISUAL", "Visual" },
              ["vs"] = { "V-CHAR (Ctrl O)", "Visual" },
              ["V"] = { "V-LINE", "Visual" },
              ["Vs"] = { "V-LINE", "Visual" },
              ---@diagnostic disable-next-line
              [""] = { "V-BLOCK", "Visual" },

              ["i"] = { "INSERT", "Insert" },
              ["ic"] = { "INSERT", "Insert" },
              ["ix"] = { "INSERT", "Insert" },

              ["t"] = { "TERMINAL", "Terminal" },

              ["R"] = { "REPLACE", "Replace" },
              ["Rc"] = { "REPLACE (Rc)", "Replace" },
              ["Rx"] = { "REPLACEa (Rx)", "Replace" },
              ["Rv"] = { "V-REPLACE", "Replace" },
              ["Rvc"] = { "V-REPLACE (Rvc)", "Replace" },
              ["Rvx"] = { "V-REPLACE (Rvx)", "Replace" },

              ["s"] = { "SELECT", "Select" },
              ["S"] = { "S-LINE", "Select" },
              ---@diagnostic disable-next-line
              [""] = { "S-BLOCK", "Select" },
              ["c"] = { "COMMAND", "Command" },
              ["cv"] = { "COMMAND", "Command" },
              ["ce"] = { "COMMAND", "Command" },
              ["cr"] = { "COMMAND", "Command" },
              ["r"] = { "PROMPT", "Confirm" },
              ["rm"] = { "MORE", "Confirm" },
              ["r?"] = { "CONFIRM", "Confirm" },
              ["x"] = { "CONFIRM", "Confirm" },
              ["!"] = { "SHELL", "Terminal" },
            },
          },
          init = function(self)
            self.mode = self.modes[vim.api.nvim_get_mode().mode]
          end,
          {
            hl = function(self)
              return "St_" .. self.mode[2] .. "Mode"
            end,
            provider = function(self)
              return " " .. self.mode[1]
            end,
          },
          {
            hl = function(self)
              return "St_" .. self.mode[2] .. "ModeSep"
            end,
            provider = "",
          },
          {
            hl = "ST_EmptySpace",
            provider = "",
          },
        },
        {
          init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
          end,
          {
            init = function(self)
              local icon, hl = require("mini.icons").get("file", self.filename)
              self.icon = icon
              self.icon_hl = hl
            end,
            hl = function(self)
              local bg = require("catppuccin.palettes").get_palette().surface0
              local fg = require("heirline.utils").get_highlight(self.icon_hl).fg

              return { bg = bg, fg = fg }
            end,
            provider = function(self)
              return " " .. self.icon .. " "
            end,
          },
          {
            hl = "St_file",
            provider = function(self)
              local filename = self.filename:match "([^/\\]+)[/\\]*$"
              return filename == "" and "No Name" or filename
            end,
          },
          {
            hl = "St_file_sep",
            provider = " ",
          },
        },
        {
          condition = function()
            return vim.b.gitsigns_head or vim.b.gitsigns_status_dict
          end,
          init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
            self.has_changes = self.status_dict.added ~= 0
              and self.status_dict.removed ~= 0
              and self.status_dict.changed ~= 0
          end,
          {
            provider = function(self)
              return " " .. self.status_dict.head
            end,
          },
          {
            provider = function(self)
              return (self.status_dict.added and self.status_dict.added ~= 0) and ("  " .. self.status_dict.added)
                or ""
            end,
          },
          {
            provider = function(self)
              return (self.status_dict.changed and self.status_dict.changed ~= 0)
                  and ("  " .. self.status_dict.changed)
                or ""
            end,
          },
          {
            provider = function(self)
              return (self.status_dict.removed and self.status_dict.removed ~= 0)
                  and ("  " .. self.status_dict.removed)
                or ""
            end,
          },
        },
        {
          provider = "%=",
        },
        {
          condition = function()
            return #vim.diagnostic.get(0) > 0 and vim.o.columns >= 85
          end,
          static = {
            error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR],
            warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN],
            info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO],
            hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT],
          },
          init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
          end,
          update = { "DiagnosticChanged", "BufEnter" },
          {
            hl = function(self)
              local hl = require("heirline.utils").get_highlight "DiagnosticError"
              hl.italic = false

              return hl
            end,
            provider = function(self)
              -- 0 is just another output, we can decide to print it or not!
              return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
            end,
          },
          {
            hl = function(self)
              local hl = require("heirline.utils").get_highlight "DiagnosticWarn"
              hl.italic = false

              return hl
            end,
            provider = function(self)
              return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
            end,
          },
          {
            hl = function(self)
              local hl = require("heirline.utils").get_highlight "DiagnosticInfo"
              hl.italic = false

              return hl
            end,
            provider = function(self)
              return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
            end,
          },
          {
            hl = function(self)
              local hl = require("heirline.utils").get_highlight "DiagnosticHint"
              hl.italic = false

              return hl
            end,
            provider = function(self)
              return self.hints > 0 and (self.hint_icon .. " " .. self.hints .. " ")
            end,
          },
        },
        {
          condition = function()
            return vim.o.columns >= 120 and next(vim.lsp.get_clients { bufnr = 0 }) ~= nil
          end,
          update = { "LspAttach", "LspDetach" },
          hl = "St_Lsp",
          provider = function()
            local servers = {}
            for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
              table.insert(servers, server.name)
            end
            return "   LSP ~ " .. table.concat(servers, " ") .. " "
          end,
        },
        {
          condition = function()
            return vim.o.columns >= 100
          end,
          {
            hl = "St_cwd_sep",
            provider = "",
          },
          {
            hl = "St_cwd_icon",
            provider = "󰉋 ",
          },
          {
            hl = "St_cwd_text",
            provider = function()
              local name = vim.uv.cwd() ---@cast name string
              return " " .. (name:match "([^/\\]+)[/\\]*$" or name) .. " "
            end,
          },
        },
        {
          {
            hl = "St_pos_sep",
            provider = "",
          },
          {
            hl = "St_pos_icon",
            provider = " ",
          },
          {
            hl = "St_pos_text",
            provider = " %l:%v ",
          },
        },
      }
    end,
  },
}
