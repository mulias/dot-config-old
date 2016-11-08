"===============================================================================
" init.vim
" My cleaned up and documented config for neovim, tailored to the features I
" need for work.
"
" Setup
" What I do to get everything working:
" * First install Plug by downloading the plugin and placing it in the nvim
"   autoload directory. I actually have plug saved with my configs in git, so
"   when I grab this file Plug will come with.
" * Now run :PlugInstall to fetch plugins.
" * Install Ag, which is used by fzf. If fzf can's find ag it falls back on
"   grep, which is ok but not as fast.
" * Install ctags, or disable gutentags.
" * Find linters for regularly used languages, configure Neomake accordingly.
" * If there's a language plugin that's better than the default provided by
"   polyglot, make sure to add that language to the 'g:polyglot_disabled'
"   array. I do this for OCaml with Merlin.
"
" Documentation
" The goal is to over-document, so that this file can act not only as a
" configuration, but as a reference for learning/relearning vim features
" beyond the basics. When possible I use the same keystroke notation used in
" the vim docs, which is specified on the ":help notation" page. I've added to
" the notation in just a few places -- namely I use {c} to mean a single
" required character, and {*} to mean a single character, restricted to the
" list immediately following.
"
" Vim Compatibility
" I'm pretty sure that all plugins and settings should be compatible with vim
" 8.0 and onwards. You'll want to change all of the hardcoded paths (plug
" path, metadata paths) to corresponding vim directories. Also add
" 'tpope/vim-sensible' to the plugins in order to get basic default settings
" that are auto-configured in neovim but not vim.
"===============================================================================


"===============================================================================
" Plugins
" Make sure Plug is manually installed first. Manage with ":PlugInstall",
" ":PlugUpdate", ":PlugClean", and ":PlugUpgrade".
"===============================================================================

call plug#begin('~/.config/nvim/plugged')

" simple file browser
" -                open file beagle in buffer directory
" {FileBeagle}+    edit new file in directory
" {FileBeagle}q    return to buffer FB was called from
" {FileBeagle}<CR> go to directory/edit file under cursor
" show hidden files and dirs, suppress the default binding of <Leader>f
Plug 'jeetsukumaran/vim-filebeagle'
let g:filebeagle_show_hidden = 1
let g:filebeagle_suppress_keymaps = 1

" smart commenting
" gc{motion}       toggle commenting on lines that {motion} moves over
" gcc              comment/uncomment line
Plug 'tpope/vim-commentary'

" manipulate surrounding pairs
" cs{c1}{c1}       change surrounding chars from {c1} to {c2}
" ds{c}            delete surrounding chars {c}
" ys{motion}{c}    add new surrounding chars {c}
" {Visual}S{c}     surround selection with {c}
Plug 'tpope/vim-surround'

" repeat find and 'till easily
" f or t           repeat last f/F/t/T motion forward
" F or T           repeat last f/F/t/T motion backward
Plug 'rhysd/clever-f.vim'
let g:clever_f_fix_key_direction = 1

" jump to next occurrence of two consecutive characters
" s{c}{c}          jump forward to next occurrence of two consecutive chars
" S{c}{c}          jump backward to previous occurrence of two consecutive chars
" s<CR>            repeat last sneak forward
" S<CR>            repeat last sneak backward
Plug 'justinmk/vim-sneak'
hi link SneakPluginTarget Search
hi link SneakPluginScope Search
let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1

" useful pairs of keybindings
" [b, [B, ]b, ]B   previous, first, next, last buffer
" [l, [L, ]l, ]L   previous, first, next, last local list entry
" [q, [Q, ]q, ]Q   previous, first, next, last quickfix list entry
" [t, [T, ]t, ]T   previous, first, next, last tag stack entry
" [e               swap current line with line [count] above
" ]e               swap current line with line [count] below
" [y{motion}       encode string with c-style escape sequences
" ]y{motion}       decode string with c-style escape sequences
" [-space          insert [count] blank line(s) above
" ]-space          insert [count] blank line(s) below
" coh              toggle hlsearch
" con              toggle line numbers
" cor              toggle relative line numbers
" cos              toggle spell check
" cow              toggle wrap
Plug 'tpope/vim-unimpaired'

" make surround and unimpaired work with the . repeat command
Plug 'tpope/vim-repeat'

" git syntax/nice defaults
Plug 'tpope/vim-git'

" git integration
" commands all start with :G
" gb               git blame in buffer (I use this a lot)
" <Leader>gb       git blame in buffer
" <Leader>gd       git diff on buffer
" <Leader>gs       git status display
Plug 'tpope/vim-fugitive'

" unix file managment integration
" includes ":SudoEdit", ":SudoWrite", ":Move", ":Remove"
Plug 'tpope/vim-eunuch'

" better in-buffer search defaults
" remove highlight after moving cursor, allow * search for selection
" {Visual}*        search for selection forward
" {Visual}#        search for selection backward
Plug 'junegunn/vim-slash'

" fuzzy find lots of things
" open fzf in a terminal buffer, with values loaded in from different sources
" <Leader>a        fzf search with ag
" <Leader>b        fzf search buffers
" <Leader>f        fzf search files in current git repo
" <Leader>gc       fzf search git commits
" <Leader>h        fzf search opened files history
" <Leader>o        fzf search all files (open file)
" <Leader>s        fzf search lines in all open buffers
" <Leader>t        fzf search ctags
" <Leader>w        fzf search working, meaning files with unstaged git changes
" <Leader>z        fzf search helptags
Plug 'junegunn/fzf', { 'dir': '~/.config/nvim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" end syntax structures automatically
Plug 'tpope/vim-endwise'

" rails navigation
" misc helpers for navigating rails apps
" gf               edit file under cursor
" ":Rpreview"      open webpage for file
" ":A"             edit 'alternate' file (usually test)
" ":R"             edit 'related' file (depends)
" ":E*"            starts many commands for editing different types of files
Plug 'tpope/vim-rails'

" program linting
" run linters asynchronously, populate the location list with errors
Plug 'neomake/neomake'
autocmd! BufWritePost * Neomake
let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']
let g:neomake_ruby_rubocop_maker = { 'args': ['-c', '.rubocop_ci.yml'] }
let g:neomake_place_signs = 0
let g:neomake_verbose = 1

" toggle location and quickfix lists
" <Leader>l        toggle location list
" <Leader>q        toggle quickfix list
Plug 'Valloric/ListToggle'

" basic syntax/indent/compiler support for many popular languages
Plug 'sheerun/vim-polyglot'

" auto generate and manage ctags
Plug 'ludovicchabant/vim-gutentags'

" view and navigate the undo tree
" <Leader>u        toggle undo tree
Plug 'mbbill/undotree'

" additional text objects
" l               text object for a while line or text in a line
" e               text object for entire buffer, with/without trailing new lines
" c               text object for a whole comment or the comment's contents
" v               text object for part of a variable, snake_case or camelCase
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'glts/vim-textobj-comment'
Plug 'Julian/vim-textobj-variable-segment'

call plug#end()


"===============================================================================
" Theme & Statusline
" I use something close to the default statusline, with the addition of
" indicating the current git branch (requires fugitive) and showing the number
" of items currently in the quickfix and location lists. The location list is
" populated by Neomake linting errors, so when the statusline shows a non-zero
" number for 'LL', I know to check for errors.
"===============================================================================

colorscheme my_theme_light

set statusline=%<                       " truncate from start
set statusline+=%f\                     " full filepath
set statusline+=%{GitBranchDisplay()}   " git branch
set statusline+=%h%q%w                  " tags: help, quickfix, preview
set statusline+=%m%r                    " tags: modified, read only
set statusline+=%=                      " right align
set statusline+=%{QFCountDisplay()}     " quickfix and location list counts
set statusline+=%12(%l,%c%)%5p%%        " line and col number, % through file


"===============================================================================
" Key Mappings (Vim ABCs)
" Common editing commands and motions, listed in alphabetical order. A key
" combo makes the list if it's something that I use frequently, or am trying to
" use more frequently.
"===============================================================================

" {Insert}<C-a>    call the omnicomplete menu
" <C-a>            insert at end of word, call the omnicomplete menu
" inoremap <C-a> <C-x><C-o>
" nnoremap <C-a> bea<C-x><C-o>

" a                insert after cursor
" A                insert at end of line

" b                move word backward
" B                move WORD backward

" c{motion}        change text
" cc               change line
" C{motion}        change text, do not save to register
" CC               change line, do not save to register
" co{*}            toggle options
"   coh            toggle hlsearch
"   con            toggle line numbers
"   cor            toggle relative line numbers
"   cos            toggle spell check
"   cow            toggle wrap
noremap C "_c
noremap CC "_cc

" d{motion}        delete text
" dd               delete line
" D{motion}        delete text, do not save to register
" DD               delete line, do not save to register
noremap D "_d
noremap DD "_dd

" e                move to end of word
" E                move to end of WORD

" f{c}             find {c} forward
" F{c}             finds {c} backwards
" f                repeat last f/F/t/T motion forward
" F                repeat last f/F/t/T motion backward
" {Insert}<C-f>    complete file name
inoremap <C-f> <C-x><C-f>

" g{*}             misc/variant actions
"   gb             fugitive git blame
"   gc{motion}     toggle commenting on lines that {motion} moves over
"   gcc            comment/uncomment line
"   gf             edit rails file under cursor (vim-rails)
"   gf             edit file at filepath under cursor
"   gg             jump to start of file, or line N
"   gp             paste from system clipboard, move cursor to end of pasted
"   {Visual}gp     paste from system clipboard over selection, move to end
"   gP             paste from system clipboard, put text before cursor
"   gq             reformat/wrap text
"   gs             give spelling suggestions
"   gu             lowercase
"   gU             uppercase
"   gy             yank to system clipboard
"   {Visual}gy     yank selection to system clipboard
"   gz             center window on cursor line
" G                jump to end of file
nnoremap gb :Gblame<CR>
noremap <silent> gp "+p`]
noremap gP "+P
nnoremap gs z=
nnoremap gy "+y
vnoremap <silent> gy "+y`]
noremap gz zz

" h                left
" H                jump high, move cursor to top of window
" <A-h>            previous buffer
" {Insert}<A-h>    previous buffer, leave insert mode
" <C-h>            focus window left
" {Insert}<C-h>    focus window left, leave insert mode
nnoremap <A-h> :bprevious<CR>
inoremap <A-h> <ESC>:bprevious<CR>
nnoremap <C-h> <C-w>h
inoremap <C-h> <ESC><C-w>h

" i                insert before cursor
" I                insert at beginning of line
" {VisualBlock}I   insert at beginning of each line in selection

" j                down
" J                down 3 lines
" <A-j>            down through wrapped line
" <C-j>            focus window below
" {Insert}<C-j>    focus window below, leave insert mode
nnoremap J jjj
vnoremap J jjj
nnoremap <A-j> gj
nnoremap <C-j> <C-w>j
inoremap <C-j> <ESC><C-w>j

" k                up
" K                up 3 lines
" <A-k>            up through wrapped line
" <C-k>            focus window above
" {Insert}<C-k>    focus window above, leave insert mode
nnoremap K kkk
vnoremap K kkk
nnoremap <A-k> gk
nnoremap <C-k> <C-w>k
inoremap <C-k> <ESC><C-w>k

" l                right
" L                jump low, move cursor to bottom of window
" <A-l>            next buffer
" {Insert}<A-l>    next buffer, leave insert mode
" <C-l>            focus window right
" {Insert}<C-l>    focus window right, leave insert mode
nnoremap <A-l> :bnext<CR>
inoremap <A-l> <ESC>:bnext<CR>
nnoremap <C-l> <C-w>l
inoremap <C-l> <ESC><C-w>l

" m{a-Z}           set mark char, where a-z marks in buffer, A-Z cross-buffers
" M                jump middle, move cursor to middle line
" mm               set mark m (jump with <Leader>m)
" mn               set mark n (jump with <Leader>n)

" n                jump to next search result
" N                jump to previous search result

" o                insert line below cursor
" O                insert line above
" {Insert}<C-o>    execute one command then return to insert mode

" p                put/paste after cursor, place cursor at end of pasted text
" {Visual}p        put/paste over selection, place cursor at end of pasted text
" P                paste before cursor
noremap <silent> p p`]

" q                record macros
" Q                run @q macro
noremap Q @q

" r                replace single character
" R                enter replace mode

" s and S          sneak actions
"   s{c}{c}        jump forward to next occurrence of two consecutive chars
"   S{c}{c}        jump backward to previous occurrence of two consecutive chars
"   s<CR>          repeat last sneak forward
"   S<CR>          repeat last sneak backward
" s and S          surround actions
"   cs{c1}{c1}     change surrounding chars from {c1} to {c2}
"   ds{c}          delete surrounding chars {c}
"   ys{motion}{c}  add new surrounding chars {c}
"   {Visual}S{c}   surround selection with {c}

" t{c}             find 'til {c} forward
" T{c}             find 'til {c} backwards
" t                repeat last f/F/t/T motion forward
" T                repeat last f/F/t/T motion backward

" u                undo
" {Visual}u        lowercase selection
" U                redo
" {Visual}U        uppercase selection
nnoremap U <C-r>

" v                enter visual mode
" V                enter visual line mode
" <C-v>            enter blockwise visual mode

" w                move word forward
" W                move WORD forward

" x                delete char forward, don't clobber register
" X                delete char backward, don't clobber register
noremap x "_x
noremap X "_X

" y                yank/copy text
" {Visual}y        yank selection, place cursor at end of selection
" Y                join two lines (Y looks like two lines joining into one)
vnoremap <silent> y y`]
noremap Y J

" z{*}             manage folds
"   zc             close fold
"   zd             delete fold
"   zf             create fold with motion
"   zo             open fold
" zz               center window on cursor
" ZZ               save and exit
" <C-z>            suspend program

" [{*}             back list entry actions
"   [b, [B         previous, first buffer
"   [l, [L         previous, first local list entry
"   [q, [Q         previous, first quickfix list entry
"   [t, [T         previous, first tag stack entry
" ]{*}             forward list entry actions
"   ]b, ]B         next, last buffer
"   ]l, ]L         next, last local list entry
"   ]q, ]Q         next, last quickfix list entry
"   ]t, ]T         next, last tag stack entry
" [e               swap current line with line [count] above
" ]e               swap current line with line [count] below
" [y{motion}       encode string with c-style escape sequences
" ]y{motion}       decode string with c-style escape sequences
" [<space>         insert [count] blank line(s) above
" ]<space>         insert [count] blank line(s) below
" <A-[>            previous jump list location
" <A-]>            next jump list location
" <C-]>            follow ctag
" <C-[>            <ESC>
nnoremap <A-[> <C-o>
nnoremap <A-]> <C-i>

" 0                go to first character of line
" ^                go to start of line
" $                go to end of line
nnoremap 0 ^
nnoremap ^ 0

" %                jump to matching brace/bracket/paren

" :                enter command mode
" ;                enter command mode
nnoremap ; :
vnoremap ; :

" {                jump to beginning of paragraph
" }                jump to end of paragraph

" /                search
" ?                search backwards

" *                search for word under cursor forward
" {Visual}*        search for selection forward
" #                search for word under cursor backwards
" {Visual}#        search for selection backward

" <<               indent left
" {Visual}<        indent selection left
" >>               indent right
" {Visual}>        indent selection right
" ==               auto indent
" {Visual}=        auto indent selection

" "[x]{ydxcp}      use register [x] for next yank, delete, or paste
" "[X]{ydxcp}      append text to register [x] for next yank or delete

" '{a-Z}           jump to mark, start of line
" `{a-Z}           jump to mark, line and column position

" .                repeat last command
" {Visual}.        repeat last command once on each line
vnoremap . :norm.<CR>

" -                open file beagle in buffer directory
" {FileBeagle}+    edit new file in directory
" {FileBeagle}q    return to buffer FB was called from
" {FileBeagle}<CR> go to directoy/edit file under cursor
nnoremap - :FileBeagleBufferDir<CR>

" <A-{*}>  auto close pair, quick and dirty version
inoremap <A-'> ''<ESC>i
inoremap <A-"> ""<ESC>i
inoremap <A-`> ``<ESC>i
inoremap <A-[> []<ESC>i
inoremap <A-{> {}<ESC>i
inoremap <A-(> ()<ESC>i


"===============================================================================
" Leader Bindings
" General convenience bindings -- search integration with fzf, git integration
" with fugitive, window split management, and misc.
"===============================================================================

" Leader
let mapleader = "\<Space>"

" <Leader>a  fzf search with ag (search all text in project)
nnoremap <silent> <Leader>a :Ag<CR>

" <Leader>b  fzf search buffers
nnoremap <silent> <Leader>b :Buffers<CR>

" <Leader>c  close focused window
nnoremap <Leader>c <C-w><C-q>

" <Leader>d  delete this buffer from buffer list, keep split/window
nnoremap <Leader>d :bp<bar>sp<bar>bn<bar>bd<CR>

" <Leader>e  refresh buffer
nnoremap <silent> <Leader>e :e<CR>

" <Leader>f  fzf search files in project/git repo
nnoremap <silent> <Leader>f :GFiles<CR>

" <Leader>g{*}  git bindings
"   <Leader>gb  fugitive git blame
"   <Leader>gc  fzf search git commits
"   <Leader>gd  fugitive git diff
"   <Leader>gs  fugitive git status
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gc :Commits<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gs :Gstatus<CR>

" <Leader>h  fzf search opened files history
nnoremap <silent> <Leader>h :History<CR>

" <Leader>i  TODO

" <Leader>I  show vim syntax highlighting groups for word under cursor
nnoremap <Leader>I :call <SID>SynStack()<CR>

" <Leader>j reformat/wrap the current paragraph/selection (join text lines)
nnoremap <Leader>j gqip
vnoremap <Leader>j gq

" <Leader>k  TODO

" <Leader>l  toggle location list

" <Leader>m  jump to mark m
nnoremap <Leader>m 'm

" <Leader>n  jump to mark n
nnoremap <Leader>n 'n

" <Leader>o  fzf search all files (open a file)
nnoremap <silent> <Leader>o :Files<CR>

" <Leader>p  TODO

" <Leader>q  toggle the quickfix list

" <Leader>r  rot13 file
noremap <Leader>r ggg?G``

" <Leader>s  fzf search lines in all open buffers
nnoremap <Leader>s :Lines<CR>

" <Leader>t  fzf search ctags
nnoremap <silent> <Leader>t :Tags<CR>

" <Leader>u  toggle undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" <Leader>v  vertical split
noremap <Leader>v :vsplit<CR>

" <Leader>w  fzf search working files, meaning files with unstaged git changes
nnoremap <silent> <Leader>w :GFiles?<CR>

" <Leader>x  close all but current window
nnoremap <Leader>x <C-w>o

" <Leader>y{c}  surround a word with {c} (weak mnemonic is You surround word)
nnoremap <Leader>y <ESC>:execute "normal \<Plug>Ysurround"<CR>g@iw

" <Leader>Y{c}  surround a WORD with {c}
nnoremap <Leader>Y <ESC>:execute "normal \<Plug>Ysurround"<CR>g@iW

" <Leader>z  fzf search helptags (helptagz?)
noremap <Leader>z :Helptags<CR>

" <Leader>=  vertically resize to split windows evenly
nnoremap <Leader>= <C-w>=

" <Leader><Leader>  switch between current and last buffer
nnoremap <Leader><Leader> <c-^>

" <Leader><tab>  TODO


"===============================================================================
" Text Objects
"===============================================================================

" i{*}             inner/inside text object
" a{*}             a/all of text object, includes surrounding whitespace
"   w              word
"   W              WORD
"   l              line
"   s              sentence
"   p              paragraph
"   t              html tags
"   [ or ], ( or ),
"   < or >, { or } matching pairs
"   `, ", '        matching quotes
"   c              comment
"   v              variable segment, either snake_case or camelCase


"===============================================================================
" Commands
" Functions that I don't use enough to motivate key bindings.
"===============================================================================

" grab the buffer list and slap it all into the current buffer
command! Bufdump call <SID>DumpBuffers()

" plug starts with ":Plug*", includes Install, Clean, Update, Upgrade

" git starts with ":G*", includes blame, diff

" unix utilities include ":SudoEdit", ":SudoWrite", ":Move", and ":Remove"

" rails
" ":Rpreview" open webpage, ":A" edit 'alternate' file (usually test)
" ":R" edit 'related' file (depends), editing specific files starts with ":E*"

" linting starts with ":Neomake*", includes Info, ListJobs, CancleJob


"===============================================================================
" All the Little Things
"===============================================================================

set showcmd                  " show command in status line as it is composed
set showmatch                " highlight matching brackets
set showmode                 " show current mode
set number                   " line numbers on the left side
set numberwidth=4            " left side number column is 4 characters wide
set expandtab                " insert spaces when TAB is pressed
set tabstop=2                " render TABs using this many spaces
set shiftwidth=2             " indentation amount for < and > commands
set noerrorbells             " no beeps
set nomodeline               " disable modeline
set nojoinspaces             " prevents inserting two spaces on a join (J)
set ignorecase               " make searching case insensitive...
set smartcase                " ... unless the query has capital letters
set wrap                     " word wrap instead of wrap by character
set colorcolumn=81           " highlight column 81
set list                     " highlight tabs and trailing spaces
set listchars=tab:>·,trail:· " symbols to display for tabs and trailing spaces
set scrolloff=3              " show next 3 lines while scrolling
set sidescrolloff=5          " show next 5 columns while side-scrolling
set splitbelow               " horizontal split opens under active window
set splitright               " vertical split opens to right of active window
set shortmess+=I             " Don't show the intro
set autowrite                " auto write file when switching buffers
set wildmode=longest:full    " bash-style command mode completion


"===============================================================================
" Metadata
" I manage meta files by keeping them all under '.config/nvim/tmp/'.
" As for which meta files to use and which to disable:
"  * Keeping an undo history has obvious benefits, and no real downsides.
"  * Backups are a matter of preference, but I have disk space so why not.
"  * Swapfiles are a mixed bag -- they provide crash resistance, but lock files
"    so that only one instance of vim can edit a file at a time. My work flow 
"    uses only one open vim session, so locking files is not a problem.
"===============================================================================

set undofile  " keep undo history persistent
set backup    " backup all files
set swapfile  " save buffers periodically
set undodir=~/.config/nvim/data/undo//           " undo files
set backupdir=~/.config/nvim/data/backup//       " backups
set directory=~/.config/nvim/data/swap//         " swap files
set shada+=n~/.config/nvim/data/shada            " shared data file
" Make those folders automatically if they don't already exist.
if !isdirectory(expand('~/.config/nvim/data'))
  call mkdir(expand('~/.config/nvim/data'), "p")
endif
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif


"===============================================================================
" Filetype Settings
" Most filetypes are dealt with by plugins, here's what's left.
"===============================================================================

" text file config, text wraps at 80 characters
autocmd FileType text setlocal textwidth=80
autocmd FileType markdown setlocal textwidth=80

" vim config config, reload vimrc every time buffer is saved
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END


"===============================================================================
" Helper Functions
" Hide these at the bottom.
"===============================================================================

" dump list of open buffers
function! <SID>DumpBuffers()
  redir => res
  silent buffers
  redir END
  silent put=res
endfunc

" vim theme building helper
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" formated string to display git branch in statusline
function! GitBranchDisplay()
  let str = fugitive#head()
  if str != ''
    let str = '[' . str . ']'
  endif
  return str
endfunc

" formated string to display quickfix/location list counts in statusline
function! QFCountDisplay()
  return 'QF ' . len(getqflist()) . ', LL ' . len(getloclist(0))
endfunc
