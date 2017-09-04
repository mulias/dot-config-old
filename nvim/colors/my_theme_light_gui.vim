" 16 color terminal colorscheme
" My terminal colors are a bit nonstandard -- 0, 7, 8, and 15 are greyscale vals
" but are not in the usual order, and the colors 9-14 are darker versions of 1-6
" instead of lighter versions.
" My colors:
"   0   #000000    8   #
"   1   #f22c40    9   #
"   2   #5ab738   10   #
"   3   #ffc71b   11   #
"   4   #407ee7   12   #
"   5   #85678f   13   #
"   6   #00ad9c   14   #
"   7   #ffffff   15   #

" The built-in vim color names don't quite match up, use these instead:

let s:none      = "None"

let s:black     = '#000000'
let s:red       = '#d80016'
let s:green     = '#328713'
let s:yellow    = '#ff9815'
let s:blue      = '#1138b4'
let s:magenta   = '#9142ac'
let s:cyan      = '#087c70'
let s:white     = '#ffffff'

let s:d_grey    = '#505050'
let s:b_red     = '#e92438'
let s:b_green   = '#5ab738'
let s:b_yellow  = '#ffd127'
let s:b_blue    = '#3678e7'
let s:b_magenta = '#85678f'
let s:b_cyan    = '#00ad9c'
let s:l_grey    = '#b1b1b1'

" And because nothing can be easy, highlight can't normally take variables, so
" use a function that evaluates the variable and passes it to highlight
fun s:hi(group, fg, bg)
  exec "hi " . a:group . " gui=None"
  exec "hi " . a:group . " guifg=" . a:fg
  exec "hi " . a:group . " guibg=" . a:bg
endfun

hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="my_theme_light_gui"

""" Colors
"         group              fg             bg
call s:hi("Black",           s:white,       s:black)
call s:hi("Red",             s:black,       s:red)
call s:hi("Green",           s:black,       s:green)
call s:hi("Yellow",          s:black,       s:yellow)
call s:hi("Blue",            s:black,       s:blue)
call s:hi("Magenta",         s:black,       s:magenta)
call s:hi("Cyan",            s:black,       s:cyan)
call s:hi("White",           s:black,       s:white)

call s:hi("DarkGrey",        s:white,       s:d_grey)
call s:hi("BrightRed",       s:black,       s:b_red)
call s:hi("BrightGreen",     s:black,       s:b_green)
call s:hi("BrightYellow",    s:black,       s:b_yellow)
call s:hi("BrightBlue",      s:black,       s:b_blue)
call s:hi("BrightMagenta",   s:black,       s:b_magenta)
call s:hi("BrightCyan",      s:black,       s:b_cyan)
call s:hi("LightGrey",       s:black,       s:l_grey)

""" Syntax groups
"         group              fg             bg
call s:hi("Comment",         s:d_grey,       s:none)   " Comment
call s:hi("Constant",        s:b_blue,        s:none)   " Constant
call s:hi("String",          s:b_magenta,     s:none)
call s:hi("Character",       s:b_magenta,     s:none)
call s:hi("Number",          s:b_magenta,     s:none)
call s:hi("Boolean",         s:b_magenta,     s:none)
call s:hi("Float",           s:b_magenta,     s:none)
call s:hi("Identifier",      s:cyan,          s:none)   " Identifier
call s:hi("Function",        s:b_cyan,        s:none)
call s:hi("Statement",       s:cyan,          s:none)   " Statment
call s:hi("Conditional",     s:b_blue,        s:none)
call s:hi("Repeat",          s:b_blue,        s:none)
call s:hi("Label",           s:b_blue,        s:none)
call s:hi("Operator",        s:b_blue,        s:none)
call s:hi("Keyword",         s:cyan,          s:none)
call s:hi("Exception",       s:b_red,         s:none)
call s:hi("PreProc",         s:b_green,       s:none)   " PreProc
call s:hi("Include",         s:b_green,       s:none)
call s:hi("Define",          s:b_green,       s:none)
call s:hi("Macro",           s:b_green,       s:none)
call s:hi("PreCondit",       s:b_green,       s:none)
call s:hi("Type",            s:blue,          s:none)   " Type
call s:hi("StorageClass",    s:blue,          s:none)
call s:hi("Structure",       s:blue,          s:none)
call s:hi("Typedef",         s:blue,          s:none)
call s:hi("Special",         s:b_magenta,     s:none)   " Special
call s:hi("SpecialChar",     s:b_magenta,     s:none)
call s:hi("Tag",             s:b_magenta,     s:none)
call s:hi("Delimiter",       s:b_magenta,     s:none)
call s:hi("SpecialComment",  s:b_magenta,     s:none)
call s:hi("Debug",           s:b_magenta,     s:none)
call s:hi("Underlined",      s:l_grey,        s:none)   " Underlined
call s:hi("Ignore",          s:white,         s:none)   " Ignore
call s:hi("Error",           s:black,         s:b_red)    " Error
call s:hi("Todo",            s:black,         s:b_yellow) " Todo

""" Highlight groups
"         group              fg             bg
call s:hi("Normal",          s:black,       s:none)
call s:hi("LineNr",          s:l_grey,      s:none)
call s:hi("CursorLineNr",    s:l_grey,      s:none)
call s:hi("ColorColumn",     s:none,        s:l_grey)
call s:hi("VertSplit",       s:white,       s:black)
call s:hi("MatchParen",      s:black,       s:b_yellow)
call s:hi("NonText",         s:b_blue,      s:none)
call s:hi("Search",          s:black,       s:b_yellow)
call s:hi("Visual",          s:none,        s:l_grey)
call s:hi("Pmenu",           s:black,       s:l_grey)
call s:hi("PmenuSel",        s:black,       s:b_cyan)
call s:hi("PmenuSbar",       s:b_blue,      s:b_red)
call s:hi("QuickFixLine",    s:black,       s:b_yellow)
call s:hi("Substitute",      s:black,       s:white)
"hi Cursor
"hi CursorIM	
"hi Directory	
"hi DiffAdd		
"hi DiffChange	
"hi DiffDelete	
"hi DiffText	
"hi ErrorMsg	
"hi Folded		
"hi FoldColumn	
"hi IncSearch	
"hi ModeMsg		
"hi MoreMsg		
"hi NonText		
"hi Question	
"hi Search		
"hi SpecialKey	
"hi StatusLine	
"hi StatusLineNC	
"hi WarningMsg	

delf s:hi
unlet s:none s:black s:d_grey s:b_red s:red s:b_green s:green s:b_yellow s:yellow
unlet s:b_blue s:blue s:b_magenta s:magenta s:b_cyan s:cyan s:white s:l_grey

