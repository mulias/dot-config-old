set nocompatible
set t_Co=16
colorscheme in_progress
syntax on
set ttyfast
set encoding=utf-8
set showcmd
set history=50
set ruler
set number
set relativenumber
" highlight CursorLineNr cterm=None ctermfg=LightGrey ctermbg=None
set numberwidth=4
" highlight LineNr cterm=None ctermfg=LightGrey ctermbg=None
nnoremap ; :
"" save file when switching to other window
au FocusLost * :wa
""  something something security exploit
set modelines=0
"" saves undo info between sessions
set undofile
set backup                        
set noswapfile                    
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
set wrap
set tabstop=2 shiftwidth=2
set expandtab
"" backspace through everything in insert mode
set backspace=indent,eol,start
set colorcolumn=81
" highlight ColorColumn cterm=None ctermbg=LightGrey
set hlsearch
set incsearch
"" searches are case insensitive...
set ignorecase
"" ... unless they contain at least one capital letter
set smartcase
"" leader
let mapleader = ","
"" clear after search
nnoremap <leader><space> :noh<cr>
"" disable arrow keys, move between lines with h and l
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

"" disable ex mode, because why?
map Q <nop>

"" use mouse
set mouse=a

"" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

"" Convenient command to see the difference between the current buffer and the
"" file it was loaded from, thus the changes you made.
"" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

function! ClipboardYank()
  call system('xclip -i -selection clipboard', @@)
endfunction
function! ClipboardPaste()
  let @@ = system('xclip -o -selection clipboard')
endfunction

vnoremap <silent> y y:call ClipboardYank()<cr>
vnoremap <silent> d d:call ClipboardYank()<cr>
vnoremap <silent> p :call ClipboardPaste()<cr>p

"" Go configs
"" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"

" Show syntax highlighting groups for word under cursor
nmap <C-S-I> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

"" disabe common movement and delete keys for practice
"noremap h <NOP>
"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>
"inoremap <BS> <NOP>
"inoremap <Del> <NOP>
"noremap <Del> <NOP>

let g:EasyMotion_leader_key = '<Leader>' 
