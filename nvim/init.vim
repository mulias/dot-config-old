"""""
" init.vim
" My cleaned up and documented config for neovim, tailored to the features I
" need for work. This config is not intended to be compatible with normal vim,
" as it uses plugins that rely on nvim's async, and does not set some options
" that are necessary for normal vim.
"
" Setup
" What I do to get everything working:
" * First install Plug by downloading the plugin and placing it in the nvim
"   autoload directory. I actually have plug saved with my configs in git, so
"   when I grab this file plug comes with.
" * Now run :PlugInstall to fetch plugins.
" * Install Ag, which is used by fzf. If fzf can's find ag it falls back on
"   grep, which is ok but not as fast.
" * Install ctags, or disable gutentags.
" * Find linters for regularly used languages, configure Neomake accordingly.
" * If there's a language plugin that's better than the default provided by
"   polyglot, make sure to add that language to the 'g:polyglot_disabled'
"   array. I do this for OCaml with merlin.
"
" Documentation
" The goal is to over-document each section, so that this file can act not
" only as a configuration, but as a reference for learning/remembering
" features beyond the vim defaults.
" * 'Plugins' lists each plugin, describes what it does, and gives the most
"   useful commands/bindings the plugin adds. Custom key bindings and settings
"   for the plugin are set right under the plug install line, so that the 
"   bindings can be easily removed along with the plugin.
" * 'Theme & Statusline' set appearence.
" * 'Key Mappings' defines general normal/visual mode mappings in roughly
"   alphabetical order. Includes comments repeating the key mappings set in
"   the plugins section.
" * 'Commands' repeats useful commands added by plugins, and defines commands
"   for calling functions in the 'Helper Functions' section.
" * 'Alt/Ctrl Bindings' and 'Leader Bindings' contain the majority of the
"   custom mappings.
" * 'All the Little Things' sets vim config params, with a short description
"   of each option.
" * 'Metadata' sets where vim files are saved.
" * 'Filetype Settings' sets rules for specific file types.
" * 'Helper Functions' defines user functions to call elsewhere in this file.
"
" Tricks/Synergies
" Some plugins/features that I've found work well together:
" * Search highlighting: vim-slash is set to turn off search highlighting
"   whenever a non-search motion is used. Usually this is what I want. Sometimes
"   though I want to search for a term, and then keep highlighting on as I work,
"   so that the search term is easily identifiable in the file. For those
"   specific situations I use 'coh' (provided by unimpaired) to toggle
"   hilighting back on again and make it stay on.
" * Linting: neomake lints the current file in the background, and sends
"   errors to the location list (use ':h location-list' to read more). Neomake
"   comes with a function for reporting the error count in the statusline, but
"   the function is broken for some linters. Neomake has another option for
"   marking error lines in the sign column, but that also behaves a little
"   weird sometimes. To get consistent and unobtrusive behavior, I directly
"   count the number of items in the location list, and print that number in
"   the statusline as 'LL num'. When there are errors, I use leader+l to open
"   the location list, and the unimpaired bindings [l, [L, l], L] to navigate
"   through the locations.
" * Auto closing pairs: in most situations lexima auto-closes pairs such as
"   [], (), '', etc. This is sometimes a problem when I'm editing, want to
"   surround some existing text, and end up with ()something like this,
"   instead of (something like this). For this case I use a visual select with 
"   vim-surround. Select the text you want inside text pairs, and use 'S(' to
"   surround with ().
"""""


"""""
" Plugins
" Make sure Plug is manually installed first. Manage with :PlugInstall, 
" :PlugUpdate, :PlugClean, :PlugUpgrade.
"""""
call plug#begin('~/.config/nvim/plugged')

" simple file browser
" open file browser with -, new file with +
Plug 'jeetsukumaran/vim-filebeagle'
let g:filebeagle_show_hidden = 1
let g:filebeagle_suppress_keymaps = 1

" smart commenting
" gcc comment/uncomment
Plug 'tpope/vim-commentary'

" manipulate surrounding pairs
" cs to change a surround, ys to add a new surround, S to surround visual
Plug 'tpope/vim-surround'

" smart select a region of text
" v for visual mode with region expand functionality, ctrl+v to shrink region
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" repeat f and t easily
" f/F/t/T to repeat last f/F/t/T action
Plug 'rhysd/clever-f.vim'
let g:clever_f_fix_key_direction = 1

" jump to next occurrence of two consecutive characters
" s/S to activate, s/S again to repeat
Plug 'justinmk/vim-sneak'
hi link SneakPluginTarget Search
hi link SneakPluginScope Search
let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1

" useful pairs of keybindings
" co[hnrsw] toggle hlsearch, line numbers, relative numbers, spell, wrap
" [+[blqt] for previous buffer/ll entry/qf entry/tab
" ]+[blqt] for next buffer/ll entry/qf entry/tab
" [+[BLQT] for first buffer/ll entry/qf entry/tab
" ]+[BLQT] for last buffer/ll entry/qf entry/tab
" [+space add [count] blank lines above the cursor
" ]+space add [count] blank lines below the cursor
" [e swap current line with line [count] above
" ]e swap current line with line [count] below
" [y / ]y encode/decode string with c-style escape sequences
Plug 'tpope/vim-unimpaired'

" git integration
" commands all start with :G
Plug 'tpope/vim-fugitive'

" unix file managment integration
" includes :SudoEdit, :SudoWrite, :Move, :Remove
Plug 'tpope/vim-eunuch'

" better in-buffer search defaults
" remove highlight after moving cursor, improve * search
Plug 'junegunn/vim-slash'

" fuzzy find lots of things
" open fzf in a terminal buffer, with values loaded in from different sources
" unmapped commands :Files, :Colors, :Lines, :Tags, :Marks, :Windows, :Locate,
" :Maps, :Helptags, :Filetypes, :BLines
Plug 'junegunn/fzf', { 'dir': '~/.config/nvim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
" Leader+a fzf search with ag
nnoremap <silent> <Leader>a :Ag<CR>
" Leader+b fzf search buffers
nnoremap <silent> <Leader>b :Buffers<CR>
" Leader+f fzf search files in git repo
nnoremap <silent> <Leader>f :GFiles<CR>
" Leader+g fzf search git commits
nnoremap <silent> <Leader>g :Commits<CR>
" Leader+h[fcs] fzf seach recent history for files, commands, and search
nnoremap <silent> <Leader>hf :History<CR>
nnoremap <silent> <Leader>hc :History:<CR>
nnoremap <silent> <Leader>hs :History/<CR>
" Leader+w fzf search working files, meaning files with unstaged git changes
nnoremap <silent> <Leader>w :GFiles?<CR>
" Leader+tab fzf search possible mappings to start/end current action
nnoremap <leader><tab> <plug>(fzf-maps-n)
xnoremap <leader><tab> <plug>(fzf-maps-x)
onoremap <leader><tab> <plug>(fzf-maps-o)
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" end syntax structures automatically
Plug 'tpope/vim-endwise'

" close matching pairs automatically
Plug 'cohama/lexima.vim'

" rails fun
" gf edit file under cursor, :Rpreview open webpage
" :A edit 'alternate' file (usually test), :R edit 'related' file (depends)
" :E[controller,helper,javascript,migration,model,spec,stylesheet,view] edits
Plug 'tpope/vim-rails'

" program linting
" run linters asynchronously, populate the location list with errors
Plug 'neomake/neomake'
autocmd! BufWritePost * Neomake
let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']
let g:neomake_ruby_rubocop_maker = { 'args': ['-c', '.rubocop_ci.yml'] }
let g:neomake_place_signs = 0
let g:neomake_verbose = 1

" basic syntax/indent/compiler support for many popular languages
Plug 'sheerun/vim-polyglot'

" auto generate and manage ctags
Plug 'ludovicchabant/vim-gutentags'

" view and navigate the undo tree
" Plug 'mbbill/undotree'

call plug#end()


"""""
" Theme & Statusline
" I use something close to the default statusline, with the addition of
" indicating the current git branch (requires fugitive) and showing the number
" of items currently in the quickfix and location lists. The location list is
" populated by Neomake linting errors, so when the statusline shows a non-zero
" number for 'LL', I know to check for errors.
"""""

colorscheme my_theme_light

set statusline=%<                       " truncate from start
set statusline+=%f\                     " full filepath
set statusline+=[%n]                    " buffer number
set statusline+=%{GitBranchDisplay()}   " git branch
set statusline+=%h%q%w                  " tags: help, quickfix, preview
set statusline+=%m%r                    " tags: modified, read only
set statusline+=%=                      " right align
set statusline+=%{QFCountDisplay()}     " quickfix and location list counts
set statusline+=%14(%l,%c%)%5p%%        " line and col number, % through file


"""""
" Key Mappings
" General bindings that don't use a special prefix key like Leader.
"""""

" co[hnrsw] toggle hlsearch, line numbers, relative numbers, spell, wrap

" cs to change a surround, ys to add a new surround, S to surround visual

" dx delete a line without saving to a register
nnoremap dx "_dd

" gcc comment/uncomment

" gf edit file under cursor (rails)

" p pastes, then places cursor at the end of pasted text
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Q to execute q register, overrides ex mode. Save a macro with qq, run with Q.
nnoremap Q @q

" s/S to sneak, s/S again to repeat

" v selects the smallest region with expand-region, ctrl+v shrinks region

" y yanks visual selection, then places cursor at end of selection
vnoremap <silent> y y`]

" 0 goes to first character and ^ goes to start of line
nnoremap 0 ^
nnoremap ^ 0

" use ; for commands
nnoremap ; :
vnoremap ; :

" make . work with visually selected lines
vnoremap . :norm.<CR>

" - opens file beagle

" [+[blqt] for previous buffer/ll entry/qf entry/tab
" ]+[blqt] for next buffer/ll entry/qf entry/tab
" [+[BLQT] for first buffer/ll entry/qf entry/tab
" ]+[BLQT] for last buffer/ll entry/qf entry/tab
" [+space add [count] blank lines above the cursor
" ]+space add [count] blank lines below the cursor
" [e swap current line with line [count] above
" ]e swap current line with line [count] below
" [y and ]y encode/decode string with c-style escape sequences


"""""
" Commands
" Functions that I don't use enough to motivate key bindings.
"""""

" grab the buffer list and slap it all into the current buffer
command! Bufdump call <SID>DumpBuffers()

" plug starts with :Plug, includes Install, Clean, Update, Upgrade

" git starts with :G, includes blame, diff

" unix utilities include :SudoEdit, :SudoWrite, :Move, :Remove

" rails
" :Rpreview open webpage, :A edit 'alternate' file (usually test)
" :R edit 'related' file (depends), editing specific files starts with :E

" linting starts with :Neomake, includes Info, ListJobs, CancleJob


"""""
" Alt/Ctrl Bindings
" I generally limit alt and ctrl to actions that are used multiple times in a
" row (like traversing the buffer list), and functions that get called in insert
" mode.
"""""

" alt+[hl] go back/forward in buffer list, leave insert mode
nnoremap <A-h> :bprevious<CR>
nnoremap <A-l> :bnext<CR>
inoremap <A-h> <ESC>:bprevious<CR>
inoremap <A-l> <ESC>:bnext<CR>

" alt+[ / alt+] go back/forward in the jump list
nnoremap <A-[> <C-o>
nnoremap <A-]> <C-i>

" ctrl+a from insert mode call the omnicomplete menu
inoremap <C-a> <C-x><C-o>

" ctrl+[hjkl] navigate between split windows, leave insert mode
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
inoremap <C-h> <ESC><C-w>h
inoremap <C-l> <ESC><C-w>l

" ctrl+v shrinks visual select region with expand-region, v expands


"""""
" Leader Bindings
" All general convenience bindings go under the leader key. Ideally each
" action should be leader plus one character, where the character is some
" moderately obvious mnemonic. In some cases a group of commands will all use
" leader plus two characters, where the first character is shared and
" represents a general kind of action, which the second character refines. For
" example, Leader+hf searches file history, Leader+hc command history, and
" Leader+hs buffer search history. I like to keep comments for unused
" bindings, so I know what is still available.
"""""

" Leader
let mapleader = "\<Space>"

" Leader+a fzf search with ag

" Leader+b fzf search buffers

" Leader+c close focused window
nnoremap <Leader>c <C-w><C-q>

" Leader+d delete this buffer from buffer list, keep split
nnoremap <Leader>d :bp<bar>sp<bar>bn<bar>bd<CR>

" Leader+e

" Leader+f fzf search files in git repo

" Leader+g fzf search git commits

" Leader+h[fcs] fzf seach recent history for files, commands, and search

" Leader+i

" Leader+I show syntax highlighting groups for word under cursor
nnoremap <Leader>I :call <SID>SynStack()<CR>

" Leader+j format the current paragraph/selection, good for ragged text
nnoremap <Leader>j gqip
vnoremap <Leader>j gq

" Leader+j

" Leader+l open the location list
nnoremap <silent> <Leader>l :lopen<CR>

" Leader+m

" Leader+n

" Leader+o

" Leader+[py] paste/yank from/to system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" Leader+q open the quickfix list
nnoremap <silent> <Leader>q :copen<CR>

" Leader+r rot13 file
noremap <Leader>r ggg?G<C-o><C-o>

" Leader+s search and replace
nnoremap <Leader>s :%s//g<Left><Left>

" Leader+t

" Leader+u toggle undotree
nnoremap <leader>u :UndotreeToggle<CR>

" Leader+v vertical split
noremap <Leader>v :vsplit<CR>

" Leader+w fzf search working files, meaning files with unstaged git changes

" Leader+x

" Leader+[yp] yank/paste to/from system clipboard
vnoremap  <Leader>y  "+y
nnoremap  <Leader>y  "+y

" Leader+z

" Leader+Leader switch between current and last buffer
nnoremap <Leader><Leader> <c-^>

" Leader+tab fzf search possible mappings to start/end current action


"""""
" All the Little Things
" I've removed all nvim default settings, even if they aren't defaults in
" normal vim. What's left is a much more managable list, but it won't make a
" good default vim setup.
"""""
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
set wrap                     " word wrap instead of map by character
set colorcolumn=81           " highlight column 81
set list                     " highlight tabs and trailing spaces
set listchars=tab:>·,trail:· " symbols to display for tabs and trailing spaces
set scrolloff=3              " show next 3 lines while scrolling
set sidescrolloff=5          " show next 5 columns while side-scrolling
set splitbelow               " horizontal split opens under active window
set splitright               " vertical split opens to right of active window
set shortmess+=I             " Don't show the intro
set autowrite                " auto write file when switching buffers
set clipboard=unnamedplus    " yank to both vim registers and system clipboard


"""""
" Metadata
" I manage meta files by keeping them all under '.config/nvim/tmp/'.
" As for which meta files to use and which to disable:
"  * Keeping an undo history has obvious benefits, and no real downsides.
"  * Backups are a matter of preference, but I have disk space so why not.
"  * Swapfiles are a mixed bag -- they provide crash resistance, but lock files
"    so that only one instance of vim can edit a file at a time. My work flow 
"    uses only one open vim session, so locking files is not a problem.
"""""
set undofile  " keep undo history persistent
set backup    " backup all files
set swapfile  " save buffers periodically
set undodir=~/.config/nvim/tmp/undo//           " undo files
set backupdir=~/.config/nvim/tmp/backup//       " backups
set directory=~/.config/nvim/tmp/swap//         " swap files
set viminfo+=n~/.config/nvim/tmp/info/viminfo   " viminfo
" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif


"""""
" Filetype Settings
" Most filetypes are dealt with by plugins, here's what is left.
"""""

" text file config, text wraps at 80 characters
autocmd FileType text setlocal textwidth=80
autocmd FileType markdown setlocal textwidth=80

" vim config config, reload vimrc every time buffer is saved
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }


"""""
" Helper Functions
" Hide these at the bottom.
"""""

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
