---@module "lazy"
---@type LazySpec
return {
  {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    opts = function(_, opts)
      opts.tabline = {
        require("heirline.utils").make_buflist {
          {
            init = function(self)
              local filename = vim.api.nvim_buf_get_name(self.bufnr)
              self.filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
            end,
            hl = function(self)
              return self.is_active and "TbBufOn" or "TbBufOff"
            end,
            on_click = {
              name = "tabline_buffer_callback",
              minwid = function(self)
                return self.bufnr
              end,
              callback = function(_, minwid)
                vim.api.nvim_win_set_buf(0, minwid)
              end,
            },
            {
              init = function(self)
                local padding = math.floor((21 - #self.filename - 5) / 2)
                self.padding = padding <= 0 and 1 or padding
              end,
              {
                provider = function(self)
                  return string.rep(" ", self.padding - 1)
                end,
              },
              {
                init = function(self)
                  local icon, hl = require("mini.icons").get("file", self.filename)
                  self.icon = icon
                  self.hl = hl
                end,
                provider = function(self)
                  return self.icon .. " "
                end,
              },
              {
                provider = function(self)
                  return self.filename
                end,
              },
              {
                provider = function(self)
                  return string.rep(" ", self.padding - 1)
                end,
              },
            },
            {
              init = function(self)
                self.modified = vim.api.nvim_get_option_value("mod", { buf = self.bufnr })
              end,
              hl = function(self)
                if self.is_active then
                  return self.modified and "TbBufOnModified" or "TbBufOnClose"
                else
                  return self.modified and "TbBufOffModified" or "TbBufOffClose"
                end
              end,
              provider = function(self)
                return self.modified and "  " or " 󰅖 "
              end,
              on_click = {
                name = "tabline_buffer_close_callback",
                minwid = function(self)
                  return self.bufnr
                end,
                callback = function(_, minwid)
                  vim.schedule(function()
                    vim.api.nvim_buf_delete(minwid, { force = false })
                    vim.cmd [[redrawtabline]]
                  end)
                end,
              },
            },
          },
        },
        {
          hl = "TbFill",
          provider = "%=",
        },
        {
          {
            hl = "TbTabNewBtn",
            provider = " 󰐕 ",
            on_click = {
              name = "tabline_tabnew_callback",
              callback = function()
                vim.cmd [[tabnew]]
              end,
            },
          },
          {
            static = { toggle = true },
            hl = "TbTabTitle",
            provider = function(self)
              return " TABS" .. ((not self.toggle and #vim.api.nvim_list_tabpages() >= 2) and "  " or " ")
            end,
            on_click = {
              name = "tabline_toogle_callback",
              callback = function(self)
                self.toggle = not self.toggle
                vim.cmd [[redrawtabline]]
              end,
            },
            {
              condition = function(self)
                return #vim.api.nvim_list_tabpages() >= 2 and self.toggle
              end,
              require("heirline.utils").make_tablist {
                {
                  hl = function(self)
                    return self.is_active and "TbTabOn" or "TabTabOff"
                  end,
                  provider = function(self)
                    return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
                  end,
                },
                {
                  condition = function(self)
                    return self.is_active
                  end,
                  hl = function(self)
                    return self.is_active and "TbTabOn" or "TabTabOff"
                  end,
                  provider = "%999X󰅙 %X",
                },
              },
            },
          },
        },
        {
          hl = "TbCloseAllBufsBtn",
          provider = " 󰅖 ",
          on_click = {
            name = "tabline_quit_callback",
            callback = function()
              vim.cmd [[quitall]]
            end,
          },
        },
      }
    end,
  },
}
