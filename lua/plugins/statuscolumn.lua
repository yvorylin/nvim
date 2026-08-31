---@module "lazy"
---@type LazySpec
return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      ---@type ffi.namespace*
      local C

      local function _ffi()
        if not C then
          local ffi = require "ffi"
          ffi.cdef [[
          typedef struct {} Error;
          typedef struct {} win_T;
          typedef struct {
            int start;  // line number where deepest fold starts
            int level;  // fold level, when zero other fields are N/A
            int llevel; // lowest level that starts in v:lnum
            int lines;  // number of lines from v:lnum to end of closed fold
          } foldinfo_T;
          foldinfo_T fold_info(win_T* wp, int lnum);
          win_T *find_window_by_handle(int Window, Error *err);
          ]]
          C = ffi.C
        end
        return C
      end

      -- Returns fold info for a given window and line number
      ---@param win number
      ---@param lnum number
      local function fold_info(win, lnum)
        pcall(_ffi)
        if not C then
          return
        end
        local ffi = require "ffi"
        local err = ffi.new "Error"
        local wp = C.find_window_by_handle(win, err)
        if wp == nil then
          return
        end
        return C.fold_info(wp, lnum)
      end

      opts.statuscolumn = {
        static = {
          left = { "mark", "sign" },
          right = { "fold", "git" },
        },
        init = function(self)
          ---@diagnostic disable-next-line
          self.signs = {}

          local lnum = vim.v.lnum
          local win = vim.api.nvim_get_current_win()
          local bufnr = vim.api.nvim_win_get_buf(win)

          local signs = {}
          local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, { details = true, type = "sign" })
          for _, extmark in pairs(extmarks) do
            if extmark[2] + 1 == lnum then
              local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""
              local ret = {
                name = name,
                type = name:find "GitSign" and "git" or "sign",
                text = extmark[4].sign_text,
                texthl = extmark[4].sign_hl_group,
                priority = extmark[4].priority,
              }
              ---@diagnostic disable-next-line
              if vim.tbl_contains(self.left, ret.type) or vim.tbl_contains(self.right, ret.type) then
                table.insert(signs, ret)
              end
            end
          end

          local marks = vim.fn.getmarklist(bufnr)
          vim.list_extend(marks, vim.fn.getmarklist())
          for _, mark in ipairs(marks) do
            if mark.pos[1] == bufnr and mark.pos[2] == lnum and mark.mark:match "[a-zA-Z]" then
              table.insert(signs, { text = mark.mark:sub(2), texthl = "StatusColumnMark", type = "mark" })
            end
          end

          local info = fold_info(win, lnum)
          if info and info.level > 0 then
            if info.lines > 0 then
              signs[#signs + 1] =
                { text = vim.opt.fillchars:get().foldclose or " ", texthl = "Folded", type = "fold" }
            end
          end

          table.sort(signs, function(a, b)
            return (a.priority or 0) > (b.priority or 0)
          end)

          if #signs > 0 then
            for _, sign in ipairs(signs) do
              self.signs[sign.type] = self.signs[sign.type] or sign
            end
          end

          self.pick_child = { 2, 1, 3 }
        end,
        {
          provider = function()
            local win = vim.api.nvim_get_current_win()
            local nu = vim.wo[win].number
            local rnu = vim.wo[win].relativenumber
            if (nu or rnu) and vim.v.virtnum == 0 then
              if rnu and nu and vim.v.relnum == 0 then
                return "%=" .. vim.v.lnum .. " "
              elseif rnu then
                return "%=" .. vim.v.relnum .. " "
              else
                return "%=" .. vim.v.lnum .. " "
              end
            end
          end,
        },
        {
          init = function(self)
            self.sign = {}
            for _, type in ipairs(self.left) do
              if self.signs[type] then
                self.sign = self.signs[type]
              end
            end
          end,
          hl = function(self)
            return self.sign and self.sign.texthl or ""
          end,
          provider = function(self)
            return self.sign and self.sign.text or "  "
          end,
        },
        {
          init = function(self)
            self.sign = {}
            for _, type in ipairs(self.right) do
              if self.signs[type] then
                self.sign = self.signs[type]
              end
            end
          end,
          hl = function(self)
            return self.sign and self.sign.texthl or ""
          end,
          provider = function(self)
            return self.sign and self.sign.text or "  "
          end,
        },
      }
    end,
  },
}
