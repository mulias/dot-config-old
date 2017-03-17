"===============================================================================
" init_plug_general.vim
" Plugins that add value to vim with minimal fuss. Everything here should work
" with both vim and nvim, and shouldn't require any initial configuration.
"===============================================================================


" Simple file browser
" -                open file beagle in buffer directory
" {FileBeagle}+    add new file in directory
" {FileBeagle}q    return to buffer FB was called from
" {FileBeagle}<CR> go to directory/edit file under cursor
" show hidden files and dirs, suppress the default binding of <Leader>f
Plug 'jeetsukumaran/vim-filebeagle'
let g:filebeagle_show_hidden = 1
let g:filebeagle_suppress_keymaps = 1


" Smart commenting
" gc{motion}       toggle commenting on lines that {motion} moves over
" gcc              comment/uncomment line
Plug 'tpope/vim-commentary'


" Manipulate surrounding pairs
" cs{c1}{c1}       change surrounding chars from {c1} to {c2}
" ds{c}            delete surrounding chars {c}
" ys{motion}{c}    add new surrounding chars {c}
" {Visual}S{c}     surround selection with {c}
" <Leader>y{c}     shortcut for ysiw{c}, surround word under cursor with {c}
" <Leader>Y{c}     shortcut for ysiW{c}, surround WORD under cursor with {c}
Plug 'tpope/vim-surround'


" Repeat find and 'till easily
" f or t           repeat last f/F/t/T motion forward
" F or T           repeat last f/F/t/T motion backward
Plug 'rhysd/clever-f.vim'
let g:clever_f_fix_key_direction = 1


" Jump to next occurrence of two consecutive characters
" s{c}{c}          jump forward to next occurrence of two consecutive chars
" S{c}{c}          jump backward to previous occurrence of two consecutive chars
" s<CR>            repeat last sneak forward
" S<CR>            repeat last sneak backward
" {Visual}s        sneak forward with visual selection
" {Visual}Z        sneak backward with visual selection (surround uses S)
Plug 'justinmk/vim-sneak'
let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1
augroup my_sneak_highlights
  au!
  autocmd ColorScheme *
        \ hi! link Sneak Search |
        \ hi! link SneakScope Visual
augroup END


" Useful pairs of keybindings, change vim settings
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


" Make surround and unimpaired work with the "." repeat command
Plug 'tpope/vim-repeat'


" Unix file management integration
" Includes ":SudoEdit", ":SudoWrite", ":Move", ":Remove".
Plug 'tpope/vim-eunuch'


" Better in-buffer search defaults
" Remove highlight after moving cursor, allow * search for selection.
" {Visual}*        search for selection forward
" {Visual}#        search for selection backward
Plug 'junegunn/vim-slash'


" Search and replace with special swoop buffer
" Scopes to either the current buffer, or all loaded buffers. Opens a swoop
" buffer, which lists all lines which include the search term. When the swoop
" buffer is saved, any changes are applied to corresponding buffers.
" <Leader>s          swoop current buffer
" {Visual}<Leader>s  swoop selection in current buffer
" <Leader>S          swoop multi buffers
" {Visual}<Leader>S  swoop selection in multi buffers
" {Swoop}:w          save changes in swoop buffer to all related lines
" {Swoop}<CR>        save changes in swoop buffer and go to selected line
Plug 'pelodelfuego/vim-swoop'
let g:swoopUseDefaultKeyMap = 0


" Briefly highlight yanked text
Plug 'machakann/vim-highlightedyank'
augroup my_yank_highlights
  au!
  autocmd ColorScheme * hi link HighlightedyankRegion DGrey
augroup END


" Fuzzy find lots of things
" Open fzf in a terminal buffer, with values loaded in from different sources.
" Install fzf locally to vim, instead or globally on the system.
" <Leader>a        fzf search with ag (search all text in project)
" <Leader>b        fzf search buffers
" <Leader>f        fzf search text in all open buffers ([f]ind text)
" <Leader>gc       fzf search git commits
" <Leader>gr       fzf search all files in current git repo
" <Leader>gs       fzf search `git status`, meaning files with unstaged changes
" <Leader>h        fzf search opened files history
" <Leader>o        fzf search all files under working directory ([o]pen a file)
" <Leader>z        fzf search ctags (ctag[z])
" <Leader>Z        fzf search helptags (helptag[Z])
" {FZF}<Tab>       select multiple results to open
" {FZF}<C-t>       open in new tab
" {FZF}<C-s>       open in horizontal split
" {FZF}<C-v>       open in vertical split
Plug 'junegunn/fzf', { 'dir': '~/.config/nvim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }


" End syntax structures automatically
Plug 'tpope/vim-endwise'


" Toggle location and quickfix lists
" TODO: set height of window
" TODO: it looks like swoop if hijacking local list toggle. Why?
" <Leader>l        toggle location list
" <Leader>q        toggle quickfix list
Plug 'Valloric/ListToggle'


" Basic syntax/indent/compiler support for many popular languages
Plug 'sheerun/vim-polyglot'


" View and navigate the undo tree
" <Leader>u        toggle undo tree
" {Undotree}?      show hotkeys and quick help
Plug 'mbbill/undotree'


" Additional text objects
" l                text object for a whole line or text in a line
" e                text object for entire buffer, with/without trailing new lines
" c                text object for a whole comment or the comment's contents
" v                text object for part of a variable, snake_case or camelCase
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'glts/vim-textobj-comment'
Plug 'Julian/vim-textobj-variable-segment'
