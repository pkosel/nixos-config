-- Light Owl colorscheme for Neovim.
-- Derived from sdras/night-owl-vscode-theme (Night Owl-Light-color-theme.json).
vim.opt.background = "light"
vim.g.colors_name = "light-owl"

local c = {
  bg = "#FBFBFB",
  fg = "#403f53",
  dark = "#F0F0F0",
  dark2 = "#E0E0E0",
  line_highlight = "#F0F0F0",
  selection = "#E0E0E0",
  line_number = "#90A7B2",
  line_number_active = "#403f53",
  cursor = "#90A7B2",
  comment = "#697098",
  string = "#4876d6",
  number = "#aa0982",
  keyword = "#0c969b",
  function_name = "#4876d6",
  variable = "#4876d6",
  type = "#111111",
  operator = "#0c969b",
  error = "#E64D49",
  warning = "#daaa01",
  info = "#4876d6",
  hint = "#90A7B2",
  constant = "#4876d6",
  tag = "#994cc3",
  attribute = "#4876d6",
  boolean = "#bc5454",
  heading = "#4876d6",
  link = "#ff869a",
  regexp = "#5ca7e4",
  delimiter = "#403f53",
  special = "#aa0982",
  builtin = "#994cc3",
  parameter = "#0c969b",
  property = "#111111",
  sign_add = "#2AA298",
  sign_change = "#daaa01",
  sign_delete = "#E64D49",
  border = "#d9d9d9",
  status_bg = "#F0F0F0",
  tab_active = "#F6F6F6",
  tab_inactive = "#F0F0F0",
  white = "#FFFFFF",
  red = "#E64D49",
  green = "#2AA298",
  yellow = "#daaa01",
  blue = "#4876d6",
  purple = "#994cc3",
  cyan = "#0c969b",
  orange = "#daaa01",
  teal = "#2AA298",
  magenta = "#994cc3",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hl("Normal", { fg = c.fg, bg = c.bg })
hl("SignColumn", { bg = c.bg })
hl("LineNr", { fg = c.line_number, bg = c.bg })
hl("CursorLineNr", { fg = c.line_number_active, bg = c.bg })
hl("CursorLine", { bg = c.line_highlight })
hl("CursorColumn", { bg = c.line_highlight })
hl("Cursor", { fg = c.bg, bg = c.cursor })
hl("ColorColumn", { bg = c.dark })
hl("FoldColumn", { fg = c.comment, bg = c.bg })
hl("Folded", { fg = c.comment, bg = c.dark })
hl("VertSplit", { fg = c.border, bg = "NONE" })
hl("WinSeparator", { fg = c.border, bg = "NONE" })
hl("Visual", { bg = c.selection })
hl("Search", { bg = c.selection, fg = c.fg })
hl("IncSearch", { bg = c.selection, fg = c.fg, bold = true })
hl("MatchParen", { bg = c.dark, bold = true })
hl("Whitespace", { fg = c.border })
hl("NonText", { fg = c.border })
hl("SpecialKey", { fg = c.border })
hl("Directory", { fg = c.blue })
hl("Title", { fg = c.blue, bold = true })
hl("Question", { fg = c.blue })
hl("MoreMsg", { fg = c.blue })
hl("ModeMsg", { fg = c.fg })
hl("WildMenu", { fg = c.fg, bg = c.dark2 })
hl("Pmenu", { fg = c.fg, bg = c.dark })
hl("PmenuSel", { fg = c.white, bg = c.blue })
hl("PmenuSbar", { bg = c.dark2 })
hl("PmenuThumb", { bg = c.border })
hl("FloatBorder", { fg = c.border, bg = c.bg })
hl("FloatTitle", { fg = c.purple, bg = c.bg, bold = true })
hl("NormalFloat", { fg = c.fg, bg = c.bg })
hl("StatusLine", { fg = c.fg, bg = c.status_bg })
hl("StatusLineNC", { fg = c.comment, bg = c.status_bg })
hl("TabLine", { fg = c.comment, bg = c.tab_inactive })
hl("TabLineSel", { fg = c.fg, bg = c.tab_active })
hl("TabLineFill", { bg = c.tab_inactive })
hl("ErrorMsg", { fg = c.red })
hl("WarningMsg", { fg = c.yellow })
hl("MsgArea", { fg = c.fg })
hl("MsgSeparator", { fg = c.border })
hl("QuickFixLine", { bg = c.dark })

-- Diagnostics
hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.info })
hl("DiagnosticHint", { fg = c.hint })
hl("DiagnosticUnderlineError", { sp = c.red, undercurl = true })
hl("DiagnosticUnderlineWarn", { sp = c.yellow, undercurl = true })
hl("DiagnosticUnderlineInfo", { sp = c.info, undercurl = true })
hl("DiagnosticUnderlineHint", { sp = c.hint, undercurl = true })

-- Syntax
hl("Comment", { fg = c.comment, italic = true })
hl("Constant", { fg = c.constant })
hl("String", { fg = c.string })
hl("Character", { fg = c.string })
hl("Number", { fg = c.number })
hl("Boolean", { fg = c.boolean })
hl("Float", { fg = c.number })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.function_name, italic = true })
hl("Statement", { fg = c.keyword, italic = true })
hl("Conditional", { fg = c.keyword, italic = true })
hl("Repeat", { fg = c.keyword, italic = true })
hl("Label", { fg = c.keyword })
hl("Operator", { fg = c.operator })
hl("Keyword", { fg = c.keyword, italic = true })
hl("Exception", { fg = c.keyword })
hl("PreProc", { fg = c.keyword })
hl("Include", { fg = c.keyword, italic = true })
hl("Define", { fg = c.keyword })
hl("Macro", { fg = c.keyword })
hl("PreCondit", { fg = c.keyword })
hl("Type", { fg = c.type })
hl("StorageClass", { fg = c.keyword, italic = true })
hl("Structure", { fg = c.keyword, italic = true })
hl("Typedef", { fg = c.type })
hl("Special", { fg = c.special })
hl("SpecialChar", { fg = c.special })
hl("SpecialComment", { fg = c.comment, italic = true })
hl("Tag", { fg = c.tag })
hl("Delimiter", { fg = c.delimiter })
hl("Debug", { fg = c.error })
hl("Error", { fg = c.error })
hl("Todo", { fg = c.blue, bg = c.dark, bold = true })
hl("Underlined", { underline = true })

-- Diff
hl("DiffAdd", { bg = "#d4edda" })
hl("DiffChange", { bg = "#d3e8f8" })
hl("DiffDelete", { fg = c.red, bg = "#f8d7da" })
hl("DiffText", { bg = "#c5dbf5", bold = true })

-- Git signs
hl("GitSignsAdd", { fg = c.sign_add })
hl("GitSignsChange", { fg = c.sign_change })
hl("GitSignsDelete", { fg = c.sign_delete })

-- Treesitter (fallbacks, treesitter-specific groups override these)
hl("@comment", { link = "Comment" })
hl("@string", { link = "String" })
hl("@number", { link = "Number" })
hl("@boolean", { link = "Boolean" })
hl("@function", { link = "Function" })
hl("@function.builtin", { fg = c.builtin })
hl("@function.call", { link = "Function" })
hl("@function.macro", { link = "Function" })
hl("@keyword", { link = "Keyword" })
hl("@keyword.function", { link = "Keyword" })
hl("@keyword.operator", { link = "Operator" })
hl("@keyword.return", { link = "Keyword" })
hl("@operator", { link = "Operator" })
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.builtin })
hl("@variable.parameter", { fg = c.parameter })
hl("@variable.member", { fg = c.property })
hl("@property", { fg = c.property })
hl("@type", { link = "Type" })
hl("@type.builtin", { link = "Type" })
hl("@constant", { link = "Constant" })
hl("@constant.builtin", { link = "Constant" })
hl("@constant.macro", { link = "Constant" })
hl("@attribute", { fg = c.attribute, italic = true })
hl("@tag", { link = "Tag" })
hl("@tag.delimiter", { link = "Delimiter" })
hl("@punctuation", { link = "Delimiter" })
hl("@punctuation.bracket", { link = "Delimiter" })
hl("@punctuation.delimiter", { link = "Delimiter" })
hl("@punctuation.special", { link = "Special" })
hl("@string.escape", { fg = c.special })
hl("@string.regexp", { fg = c.regexp })
hl("@string.special", { link = "Special" })
hl("@markup.heading", { fg = c.heading, bold = true })
hl("@markup.link", { fg = c.link })
hl("@markup.link.label", { fg = c.link })
hl("@markup.raw", { fg = c.cyan })
hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.list", { fg = c.blue })
hl("@diff.plus", { fg = c.sign_add })
hl("@diff.minus", { fg = c.sign_delete })
hl("@diff.delta", { fg = c.sign_change })
hl("@tag.attribute", { fg = c.attribute, italic = true })
hl("@constructor", { fg = c.type })
hl("@module", { fg = c.type })
hl("@namespace", { fg = c.type })
hl("@text.note", { fg = c.blue })
hl("@text.warning", { fg = c.yellow })
hl("@text.danger", { fg = c.red })
hl("@text.diff.add", { fg = c.sign_add })
hl("@text.diff.delete", { fg = c.sign_delete })

-- LSP
hl("LspReferenceText", { bg = c.dark2 })
hl("LspReferenceRead", { bg = c.dark2 })
hl("LspReferenceWrite", { bg = c.dark2 })
