" use vim-plug for plugins
" :PlugInstall to install, :PlugUpdate to update all, :PlugClean to remove unused
call plug#begin('~/.config/nvim/plugged')

" simple file browser
" defaults bind Leader+f to open file browser
Plug 'jeetsukumaran/vim-filebeagle'

" manipulate surrounding pairs
Plug 'tpope/vim-surround'

" fast file navigation, activate with leader+leader
Plug 'easymotion/vim-easymotion'

" runs a linter and reports errors on file save
Plug 'scrooloose/syntastic'
let g:syntastic_ocaml_checkers = ['merlin']    " OCaml linter is merlin
let g:syntastic_ocaml_checkers = ['rubylint']  " Ruby linter is ruby-lint

" indents ocaml files, ocp-indent is installed with opam
Plug 'let-def/ocp-indent-vim', { 'for': 'ocaml' }

call plug#end()

" theme
colorscheme my_theme_light

" Leader
let mapleader = "\<Space>"
map <Leader> <Plug>(easymotion-prefix)
" Local Leader (used for filetype specific bindings)
let maplocalleader = "\\"

" use ; for commands.
nnoremap ; :

" use Q to execute default register.
nnoremap Q @q

" all the little things
set showcmd             " show command in status line as it is composed.
set showmatch           " highlight matching brackets.
set showmode            " show current mode.
set ruler               " the line and column numbers of the cursor.
set number              " line numbers on the left side.
set relativenumber      " line number of current line, all other numbers relative
set numberwidth=4       " left side number column is 4 characters wide.
set expandtab           " insert spaces when TAB is pressed.
set tabstop=2           " render TABs using this many spaces.
set shiftwidth=2        " indentation amount for < and > commands.
set noerrorbells        " no beeps.
set nomodeline          " disable modeline.
set nojoinspaces        " prevents inserting two spaces on a join (J)
set ignorecase          " make searching case insensitive...
set smartcase           " ... unless the query has capital letters.
set wrap                " word wrap instead of map by character.
set colorcolumn=81      " highlight column 81
set list                " highlight tabs and trailing spaces
set listchars=tab:>·,trail:· " symbols to display for tabs and trailing spaces
set scrolloff=3         " show next 3 lines while scrolling.
set sidescrolloff=5     " show next 5 columns while side-scrolling.
set autochdir           " switch to current file's parent directory.

" ctrl+[hjkl] navigate between split windows with
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Leader+/ clear highlight after search
nnoremap <Leader>/ :noh<cr>

" Leader+y copy to system clipboard
vnoremap  <Leader>y  "+y
nnoremap  <Leader>y  "+y

" Leader+p paste from system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" Leader+[hl] go back/forward in buffer list
nmap <Leader>h :bprevious<CR>
nmap <Leader>l :bnext<CR>

" Leader+s search and replace
nmap <Leader>s :%s//g<Left><Left>

" Leader+b list buffers
nmap <Leader>b :ls<CR>:buffer<Space>

" Leader+t toggle between current and last buffer
nmap <Leader>t <c-^>

" Leader+i show syntax highlighting groups for word under cursor
nmap <Leader>i :call <SID>SynStack()<CR>

" ctrl+a in insert mode calls the omnicomplete menu
inoremap <C-a> <C-x><C-o>

" w!! save a file with sudo even if it was opened without
cnoremap  w!! w !sudo tee % > /dev/null

" Leader+c close focused window
nmap <Leader>c <C-w><C-q>

" Leader+[hv] horizontal/vertical split
noremap <Leader>h :split<CR>
noremap <Leader>v :vsplit<CR>

" manage meta files by keeping them all under .config/nvim/tmp/
set undofile  " keep undo history persistent
set backup    " backup all files
set swapfile  " save buffers periodically
"" save backup and swap stuff in directories
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

" text file config
autocmd FileType text setlocal textwidth=80

" OCaml config
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" Vim theme building helper
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

