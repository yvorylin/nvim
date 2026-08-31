---@module "lazy"
---@type LazySpec
return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    ---@module "catppuccin"
    ---@type CatppuccinOptions
    opts = {
      custom_highlights = function(colors)
        return {
          BlinkCmpKindText = { bg = colors.green, fg = colors.mantle },
          BlinkCmpKindMethod = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindFunction = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindConstructor = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindField = { bg = colors.green, fg = colors.mantle },
          BlinkCmpKindVariable = { bg = colors.flamingo, fg = colors.mantle },
          BlinkCmpKindClass = { bg = colors.yellow, fg = colors.mantle },
          BlinkCmpKindInterface = { bg = colors.yellow, fg = colors.mantle },
          BlinkCmpKindModule = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindProperty = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindUnit = { bg = colors.green, fg = colors.mantle },
          BlinkCmpKindValue = { bg = colors.peach, fg = colors.mantle },
          BlinkCmpKindEnum = { bg = colors.yellow, fg = colors.mantle },
          BlinkCmpKindKeyword = { bg = colors.mauve, fg = colors.mantle },
          BlinkCmpKindSnippet = { bg = colors.flamingo, fg = colors.mantle },
          BlinkCmpKindColor = { bg = colors.red, fg = colors.mantle },
          BlinkCmpKindFile = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindReference = { bg = colors.red, fg = colors.mantle },
          BlinkCmpKindFolder = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindEnumMember = { bg = colors.teal, fg = colors.mantle },
          BlinkCmpKindConstant = { bg = colors.peach, fg = colors.mantle },
          BlinkCmpKindStruct = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindEvent = { bg = colors.blue, fg = colors.mantle },
          BlinkCmpKindOperator = { bg = colors.sky, fg = colors.mantle },
          BlinkCmpKindTypeParameter = { bg = colors.maroon, fg = colors.mantle },
          BlinkCmpKindCopilot = { bg = colors.teal, fg = colors.mantle },

          -- statusline
          St_EmptySpace = { bg = colors.surface0, fg = colors.surface1 },
          St_file = { bg = colors.surface0, fg = colors.text },
          St_file_sep = { bg = colors.mantle, fg = colors.surface0 },
          St_Lsp = { bg = colors.mantle, fg = colors.sky },
          St_cwd_sep = { bg = colors.mantle, fg = colors.red },
          St_cwd_icon = { bg = colors.red, fg = colors.mantle },
          St_cwd_text = { bg = colors.mantle, fg = colors.overlay0 },
          St_pos_sep = { bg = colors.mantle, fg = colors.green },
          St_pos_icon = { bg = colors.green, fg = colors.mantle },
          St_pos_text = { bg = colors.mantle, fg = colors.overlay0 },

          St_NormalMode = { bg = colors.sapphire, fg = colors.mantle, bold = true },
          St_NormalModeSep = { bg = colors.surface1, fg = colors.sapphire },
          St_VisualMode = { bg = colors.mauve, fg = colors.mantle, bold = true },
          St_VisualModeSep = { bg = colors.surface1, fg = colors.mauve },
          St_InsertMode = { bg = colors.maroon, fg = colors.mantle, bold = true },
          St_InsertModeSep = { bg = colors.surface1, fg = colors.maroon },
          St_TerminalMode = { bg = colors.green, fg = colors.mantle, bold = true },
          St_TerminalModeSep = { bg = colors.surface1, fg = colors.green },
          St_NTerminalMode = { bg = colors.yellow, fg = colors.mantle, bold = true },
          St_NTerminalModeSep = { bg = colors.surface1, fg = colors.yellow },
          St_ReplaceMode = { bg = colors.peach, fg = colors.mantle, bold = true },
          St_ReplaceModeSep = { bg = colors.surface1, fg = colors.peach },
          St_ConfirmMode = { bg = colors.teal, fg = colors.mantle, bold = true },
          St_ConfirmModeSep = { bg = colors.surface1, fg = colors.teal },
          St_CommandMode = { bg = colors.green, fg = colors.mantle, bold = true },
          St_CommandModeSep = { bg = colors.surface1, fg = colors.green },
          St_SelectMode = { bg = colors.sky, fg = colors.mantle, bold = true },
          St_SelectModeSep = { bg = colors.surface1, fg = colors.sky },

          -- tabline
          TbBufOn = { bg = colors.base, fg = colors.text },
          TbBufOff = { bg = colors.mantle, fg = colors.surface1 },
          TbBufOnModified = { bg = colors.base, fg = colors.peach },
          TbBufOffModified = { bg = colors.mantle, fg = colors.peach },
          TbBufOnClose = { bg = colors.base, fg = colors.red },
          TbBufOffClose = { bg = colors.mantle, fg = colors.surface1 },
          TbTabNewBtn = { bg = colors.surface0, fg = colors.subtext0 },
          TbTabTitle = { bg = colors.subtext0, fg = colors.surface0 },
          TbTabOn = { bg = colors.blue, fg = colors.mantle },
          TbTabOff = { bg = colors.surface0, fg = colors.subtext0 },
          TbCloseAllBufsBtn = { bg = colors.red, fg = colors.mantle },
        }
      end,
    },
    config = function(_, opts)
      local catppuccin = require "catppuccin"

      catppuccin.setup(opts)
      catppuccin.load()
    end,
  },
}
