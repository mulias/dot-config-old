"""""
" Plugins
" :PlugInstall to install, :PlugUpdate to update all, :PlugClean to remove unused
call plug#begin('~/.config/nvim/plugged')

" simple file browser
" open file browser with -, new file with +
Plug 'jeetsukumaran/vim-filebeagle'
let g:filebeagle_show_hidden = 1
let g:filebeagle_suppress_keymaps = 1
map <silent> - <Plug>FileBeagleOpenCurrentBufferDir

" smart commenting
" comment/uncomment with gcc
Plug 'tpope/vim-commentary'

" manipulate surrounding pairs
" cs to change a surround, ys to add a new surround
Plug 'tpope/vim-surround'

" smart select a region of text
" v for visual mode with region expand functionality, ctrl+v to shrink region
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" repeat f and t easily
" f/F/t/T to repeat last f/t action
Plug 'rhysd/clever-f.vim'
let g:clever_f_fix_key_direction = 1

" jump to next occurrence of two consecutive characters
Plug 'justinmk/vim-sneak'
hi link SneakPluginTarget Search
hi link SneakPluginScope Search
let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1

" git integration
" commands all start with :G
Plug 'tpope/vim-fugitive'

" unix file managment integration
" :SudoEdit, :SudoWrite, :Move, :Remove, ...
Plug 'tpope/vim-eunuch'

" better in-buffer search defaults
" remove hihglight after moving cursor, improve * search
Plug 'junegunn/vim-slash'

" fuzzy find lots of things
Plug 'junegunn/fzf', { 'dir': '~/.config/nvim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" end syntax structures automatically
Plug 'tpope/vim-endwise'

" ruby fun
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'

" runs a linter and reports errors on file save
Plug 'scrooloose/syntastic'
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_ruby_rubocop_args = "-c .rubocop_ci.yml"
let g:syntastic_elixir_checkers = ['elixir']
let g:syntastic_enable_elixir_checker = 1

" elixir highlighting and indentation
Plug 'elixir-lang/vim-elixir'

" slim highlighting
Plug 'slim-template/vim-slim'

call plug#end()


"""""
" Theme
colorscheme my_theme_light


"""""
" Key Mappings
" use ; for commands
nnoremap ; :
vnoremap ; :

" use Q to execute default register, overrides ex mode.
nnoremap Q @q

" 0 goes to first character and ^ goes to start of line
nnoremap 0 ^
nnoremap ^ 0

" make . work with visually selected lines
vnoremap . :norm.<CR>

" dx delete a line without saving to a register
nnoremap dx "_dd

" - opens file beagle

" v selects the smallest region with expand-region, ctrl+v shrinks region


"""""
" Alt Bindings
" alt+[hl] go back/forward in buffer list
nnoremap <A-h> :bprevious<CR>
nnoremap <A-l> :bnext<CR>


"""""
" Ctrl Bindings
" ctrl+a from insert mode call the omnicomplete menu
inoremap <C-a> <C-x><C-o>

" ctrl+[hjkl] navigate between split windows with
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" ctrl+s toggle spellcheck for comments
nnoremap <C-s> :setlocal invspell<CR>

" ctrl+v shrinks visual selectr region with expand-region, v expands


"""""
" Leader Bindings
" Leader
let mapleader = "\<Space>"

" Leader+a fzf search with ag
nnoremap <silent> <Leader>a :Ag<CR>

" Leader+b fzf search buffers
nnoremap <silent> <Leader>b :Buffers<CR>

" Leader+c close focused window
nmap <Leader>c <C-w><C-q>

" Leader+d delete this buffer from buffer list, keep split
nmap <Leader>d :bp<bar>sp<bar>bn<bar>bd<CR>

" Leader+e

" Leader+f fzf search files in git repo
nnoremap <silent> <Leader>f :GFiles<CR>

" Leader+g fzf search git commits
nnoremap <silent> <Leader>g :Commits<CR>

" Leader+h[fcs] fzf seach recent history for files, commands, and search
nnoremap <silent> <Leader>hf :History<CR>
nnoremap <silent> <Leader>hc :History:<CR>
nnoremap <silent> <Leader>hs :History/<CR>

" Leader+i

" Leader+I show syntax highlighting groups for word under cursor
nmap <Leader>I :call <SID>SynStack()<CR>

" Leader+j format the current paragraph/selection, good for ragged text
nmap <Leader>j gqip
vmap <Leader>j gq

" Leader+j

" Leader+l fzf search lines in current buffer
nnoremap <silent> <Leader>l :BLines<CR>

" Leader+m

" Leader+n

" Leader+o

" Leader+[py] paste/yank from/to system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" Leader+q

" Leader+r rot13 file
noremap <Leader>r ggg?G

" Leader+s search and replace
nmap <Leader>s :%s//g<Left><Left>

" Leader+t

" Leader+u

" Leader+v vertical split
noremap <Leader>v :vsplit<CR>

" Leader+w fzf search working files, menaing files with unstaged git changes
nnoremap <silent> <Leader>w :GFiles?<CR>

" Leader+x

" Leader+[py] paste/yank from/to system clipboard
vnoremap  <Leader>y  "+y
nnoremap  <Leader>y  "+y

" Leader+z

" Leader+Leader switch between current and last buffer
nmap <Leader><Leader> <c-^>


"""""
" All the Little Things
set showcmd                  " show command in status line as it is composed
set showmatch                " highlight matching brackets
set showmode                 " show current mode
set ruler                    " the line and column numbers of the cursor
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
" Vim Metadata
" manage meta files by keeping them all under .config/nvim/tmp/
set undofile  " keep undo history persistent
set backup    " backup all files
set swapfile  " save buffers periodically
" save backup and swap stuff in directories
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
" text file config, text wraps at 80 characters
autocmd FileType text setlocal textwidth=80

" vim config config, reload vimrc every time buffer is saved
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" dump list of open buffers
function! <SID>DumpBuffers()
  redir => res
  silent buffers
  redir END
  silent put=res
endfunc

command! Bufdump call <SID>DumpBuffers()

" Vim theme building helper
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
