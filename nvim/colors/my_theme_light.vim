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
let s:none     =  "None"
let s:black    =  "00"
let s:dgrey    =  "08"
let s:red      =  "01"
let s:dred     =  "09"
let s:green    =  "02"
let s:dgreen   =  "10"
let s:yellow   =  "03"
let s:dyellow  =  "11"
let s:blue     =  "04"
let s:dblue    =  "12"
let s:magenta  =  "05"
let s:dmagenta =  "13"
let s:cyan     =  "06"
let s:dcyan    =  "14"
let s:lgrey    =  "07"
let s:white    =  "15"

" And because nothing can be easy, highlight can't normally take variables, so
" use a function that evaluates the variable and passes it to highlight
fun s:hi(group, fg, bg)
  exec "hi " . a:group . " cterm=None"
  exec "hi " . a:group . " ctermfg=" . a:fg
  exec "hi " . a:group . " ctermbg=" . a:bg
endfun

hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="my_theme_light"

""" Colors
"         group              fg             bg
call s:hi("Black",           s:white,       s:black)
call s:hi("DGrey",           s:white,       s:dgrey)
call s:hi("Red",             s:black,       s:red)
call s:hi("DRed",            s:black,       s:dred)
call s:hi("Green",           s:black,       s:green)
call s:hi("DGreen",          s:black,       s:dgreen)
call s:hi("Yellow",          s:black,       s:yellow)
call s:hi("DYellow",         s:black,       s:dyellow)
call s:hi("Blue",            s:black,       s:blue)
call s:hi("DBlue",           s:black,       s:dblue)
call s:hi("Magenta",         s:black,       s:magenta)
call s:hi("DMagenta",        s:black,       s:dmagenta)
call s:hi("Cyan",            s:black,       s:cyan)
call s:hi("DCyan",           s:black,       s:dcyan)
call s:hi("LGrey",           s:black,       s:lgrey)
call s:hi("White",           s:black,       s:white)

""" Syntax groups
"         group              fg             bg
call s:hi("Comment",         s:dgrey,       s:none)   " Comment
call s:hi("Constant",        s:blue,        s:none)   " Constant
call s:hi("String",          s:magenta,     s:none)	     
call s:hi("Character",       s:magenta,     s:none)	     
call s:hi("Number",          s:magenta,         s:none)     
call s:hi("Boolean",         s:magenta,         s:none)     
call s:hi("Float",           s:magenta,         s:none)     
call s:hi("Identifier",      s:dcyan,       s:none)   " Identifier
call s:hi("Function",        s:cyan,        s:none)
call s:hi("Statement",       s:dcyan,       s:none)   " Statment
call s:hi("Conditional",     s:blue,        s:none)
call s:hi("Repeat",          s:blue,        s:none)
call s:hi("Label",           s:blue,        s:none)
call s:hi("Operator",        s:blue,        s:none)
call s:hi("Keyword",         s:dcyan,       s:none)
call s:hi("Exception",       s:red,         s:none)
call s:hi("PreProc",         s:green,       s:none)   " PreProc
call s:hi("Include",         s:green,       s:none)
call s:hi("Define",          s:green,       s:none)
call s:hi("Macro",           s:green,       s:none)
call s:hi("PreCondit",       s:green,       s:none)
call s:hi("Type",            s:dblue,       s:none)   " Type
call s:hi("StorageClass",    s:dblue,       s:none)
call s:hi("Structure",       s:dblue,       s:none)
call s:hi("Typedef",         s:dblue,       s:none)
call s:hi("Special",         s:magenta,     s:none)   " Special
call s:hi("SpecialChar",     s:magenta,     s:none)
call s:hi("Tag",             s:magenta,     s:none)
call s:hi("Delimiter",       s:magenta,     s:none)
call s:hi("SpecialComment",  s:magenta,     s:none)
call s:hi("Debug",           s:magenta,     s:none)
call s:hi("Underlined",      s:lgrey,       s:none)   " Underlined
call s:hi("Ignore",          s:white,       s:none)   " Ignore
call s:hi("Error",           s:black,       s:red)    " Error
call s:hi("Todo",            s:black,       s:yellow) " Todo

""" Highlight groups
"         group              fg             bg
call s:hi("Normal",          s:black,       s:none)
call s:hi("LineNr",          s:lgrey,       s:none)
call s:hi("CursorLineNr",    s:lgrey,       s:none)
call s:hi("ColorColumn",     s:none,        s:lgrey)
call s:hi("VertSplit",       s:white,       s:black)
call s:hi("MatchParen",      s:black,       s:yellow)
call s:hi("NonText",         s:blue,        s:none)
call s:hi("Search",          s:black,       s:yellow)
call s:hi("Visual",          s:none,        s:lgrey)
call s:hi("Pmenu",           s:black,       s:lgrey)
call s:hi("PmenuSel",        s:black,       s:cyan)
call s:hi("PmenuSbar",       s:blue,        s:red)
call s:hi("QuickFixLine",    s:black,       s:yellow)
call s:hi("Substitute",    s:black,        s:white)
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
unlet s:none s:black s:dgrey s:red s:dred s:green s:dgreen s:yellow s:dyellow
unlet s:blue s:dblue s:magenta s:dmagenta s:cyan s:dcyan s:white s:lgrey
