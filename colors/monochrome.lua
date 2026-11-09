vim.o.termguicolors = true
vim.o.background = "light"
vim.cmd("hi clear")

if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "monochrome"

-- Pure monochrome: off-white paper, black ink. No hue anywhere.
-- Hierarchy is expressed entirely through shade (6 gray values) and
-- typography (bold / italic / underline). Inverted search for maximum pop.
local c = {
    bg       = "#f5f5f5",
    mantle   = "#f2f2f2",
    crust    = "#e6e6e6",
    surface0 = "#eeeeee", -- CursorLine — clearly distinct from bg
    surface1 = "#c0c0c0", -- LineNr, inactive chrome
    surface2 = "#e0e0e0",

    fg       = "#151515", -- main text
    subtext  = "#404040",
    comment  = "#b0b0b0", -- light ash — de-emphasised

    -- six named shades for syntax
    jet      = "#111111", -- darkest  → keyword
    charcoal = "#1e1e1e", -- very dark → function, constant
    graphite = "#3c3c3c", -- dark      → type, number, member
    iron     = "#5a5a5a", -- mid       → string, operator, preproc
    smoke    = "#787878", -- mid-light → special, label, dim
    ash      = "#b0b0b0", -- light     → comment, conceal

    comet_bg = "#f4f4f4",

    muted_slate_blue = "#4B6B94",
    muted_slate_blue_light = "#5B7B9A",

    sage_green = "#5E7D63",
    sage_green_light = "#6C8B74",

    terracotta = "#A05246",
    terracotta_dark = "#8B4538",

    muted_warm_amber = "#B8860B",
    muted_warm_amber_dark = "#A67C1E",

    ref_text = "#d3dad4",
    ref_write = "#e3d8d6",
}

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Base UI
hl("Normal", { fg = c.fg, bg = c.comet_bg })
hl("NormalNC", { fg = c.subtext, bg = c.bg })
hl("NormalFloat", { fg = c.fg, bg = c.mantle })
hl("FloatBorder", { fg = c.surface2, bg = c.mantle })
hl("FloatTitle", { fg = c.jet, bg = c.mantle })

hl("ColorColumn", { bg = c.surface0 })
hl("Cursor", { fg = c.bg, bg = c.jet })
hl("CursorLine", { bg = c.surface0 })
hl("CursorColumn", { bg = c.surface0 })
hl("LineNr", { fg = c.surface1 })
hl("CursorLineNr", { fg = c.graphite, bold = true })

hl("SignColumn", { bg = c.bg })
hl("EndOfBuffer", { fg = c.bg })
hl("VertSplit", { fg = c.surface1, bg = c.bg })
hl("WinSeparator", { fg = c.surface1, bg = c.bg })

hl("Folded", { fg = c.smoke, bg = c.surface0, italic = true })
hl("FoldColumn", { fg = c.surface1, bg = c.bg })

hl("StatusLine", { fg = c.fg, bg = c.surface0 })
hl("StatusLineNC", { fg = c.surface1, bg = c.mantle })
hl("TabLine", { fg = c.surface1, bg = c.mantle })
hl("TabLineFill", { bg = c.crust })
hl("TabLineSel", { fg = c.bg, bg = c.jet, bold = true })

hl("Pmenu", { fg = c.fg, bg = c.mantle })
hl("PmenuSel", { fg = c.bg, bg = c.charcoal, bold = true })
hl("PmenuSbar", { bg = c.surface0 })
hl("PmenuThumb", { bg = c.surface2 })

-- inverted search: black bg / white fg — maximum pop without any hue
hl("Visual", { bg = "#d8d8d8" })
hl("VisualNOS", { bg = "#d8d8d8" })
hl("Search", { fg = c.bg, bg = c.jet, bold = true })
hl("IncSearch", { fg = c.bg, bg = c.graphite, bold = true })
hl("MatchParen", { bold = true, underline = true })

hl("Comment", { fg = c.ash, italic = true })
hl("Conceal", { fg = c.smoke })
hl("Directory", { fg = c.jet, bold = true })
hl("Title", { fg = c.jet, bold = true })

-- Syntax — shade + weight only, no hue
hl("Constant", { fg = c.charcoal, italic = true })
hl("String", { fg = c.iron, italic = true })
hl("Character", { fg = c.iron, italic = true })
hl("Number", { fg = c.graphite })
hl("Boolean", { fg = c.jet, italic = true })
hl("Float", { fg = c.graphite })

hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.charcoal, bold = true })

hl("Statement", { fg = c.jet })
hl("Conditional", { fg = c.jet })
hl("Repeat", { fg = c.jet })
hl("Label", { fg = c.smoke })
hl("Operator", { fg = c.iron })
hl("Keyword", { fg = c.jet })
hl("Exception", { fg = c.jet, bold = true, italic = true })

hl("PreProc", { fg = c.iron })
hl("Include", { fg = c.graphite, bold = true })
hl("Define", { fg = c.iron })
hl("Macro", { fg = c.iron })
hl("PreCondit", { fg = c.iron })

hl("Type", { fg = c.graphite, italic = true })
hl("StorageClass", { fg = c.jet })
hl("Structure", { fg = c.charcoal, italic = true })
hl("Typedef", { fg = c.graphite, italic = true })

hl("Special", { fg = c.smoke })
hl("SpecialChar", { fg = c.iron })
hl("Tag", { fg = c.charcoal })
hl("Delimiter", { fg = c.subtext })
hl("SpecialComment", { fg = c.ash, italic = true })
hl("Debug", { fg = c.jet, underline = true })

hl("Underlined", { fg = c.charcoal, underline = true })
hl("Bold", { bold = true })
hl("Italic", { italic = true })

hl("Error", { fg = c.jet, bold = true, underline = true })
hl("ErrorMsg", { fg = c.jet, bold = true, underline = true })
hl("WarningMsg", { fg = c.graphite, bold = true })
hl("Todo", { fg = c.bg, bg = c.jet, bold = true })

-- Treesitter
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.graphite, italic = true })
hl("@variable.parameter", { fg = c.iron, italic = true })
hl("@variable.member", { fg = c.graphite })

hl("@constant", { fg = c.charcoal, bold = true })
hl("@constant.builtin", { fg = c.jet, bold = true, italic = true })
hl("@module", { fg = c.charcoal, bold = true })
hl("@label", { fg = c.smoke })

hl("@string", { fg = c.iron, italic = true })
hl("@string.escape", { fg = c.graphite })
hl("@string.regex", { fg = c.graphite, italic = true })

hl("@number", { fg = c.graphite })
hl("@boolean", { fg = c.jet, bold = true })

hl("@type", { fg = c.graphite, italic = true })
hl("@type.builtin", { fg = c.charcoal, italic = true })
hl("@attribute", { fg = c.smoke })
hl("@property", { fg = c.graphite })

hl("@function", { fg = c.charcoal, bold = true, italic = true })
hl("@function.builtin", { fg = c.jet, bold = true })
hl("@function.method", { fg = c.charcoal, bold = true })
hl("@constructor", { fg = c.charcoal, bold = true, italic = true })

hl("@keyword", { fg = c.jet, bold = true })
hl("@keyword.function", { fg = c.jet, bold = true })
hl("@keyword.return", { fg = c.jet, bold = true, italic = true })
hl("@operator", { fg = c.iron })

hl("@punctuation.delimiter", { fg = c.subtext })
hl("@punctuation.bracket", { fg = c.subtext })
hl("@punctuation.special", { fg = c.iron })

hl("@tag", { fg = c.charcoal })
hl("@tag.attribute", { fg = c.graphite, italic = true })
hl("@tag.delimiter", { fg = c.subtext })

hl("@markup.heading", { fg = c.jet, bold = true })
hl("@markup.link", { fg = c.charcoal, underline = true })
hl("@markup.raw", { fg = c.iron, italic = true })

-- Diagnostics / LSP — severity shown by shade + style, no hue
hl("DiagnosticError", { fg = c.jet, bold = true })
hl("DiagnosticWarn", { fg = c.graphite, bold = true })
hl("DiagnosticInfo", { fg = c.iron })
hl("DiagnosticHint", { fg = c.smoke })
hl("DiagnosticOk", { fg = c.ash })

hl("DiagnosticVirtualTextError", { fg = c.jet, bg = c.surface0, bold = true })
hl("DiagnosticVirtualTextWarn", { fg = c.graphite, bg = c.surface0 })
hl("DiagnosticVirtualTextInfo", { fg = c.iron, bg = c.surface0 })
hl("DiagnosticVirtualTextHint", { fg = c.smoke, bg = c.surface0 })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.jet })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.graphite })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.iron })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.smoke })

hl("LspReferenceText", { bg = c.ref_text })
hl("LspReferenceRead", { bg = c.ref_text })
hl("LspReferenceWrite", { bg = c.ref_write, underline = true, sp = c.terracotta })
hl("LspSignatureActiveParameter", { fg = c.terracotta_dark, bg = c.ref_write, bold = true, underline = true, sp = c.terracotta_dark })

-- Diff / Git — shade bands only
hl("DiffAdd", { fg = c.charcoal, bg = "#e8e8e8" })
hl("DiffChange", { fg = c.graphite, bg = "#ebebeb" })
hl("DiffDelete", { fg = c.jet, bg = "#d8d8d8", bold = true })
hl("DiffText", { fg = c.jet, bg = "#d8d8d8", bold = true })

hl("GitSignsAdd", { fg = c.graphite })
hl("GitSignsChange", { fg = c.iron })
hl("GitSignsDelete", { fg = c.jet })
