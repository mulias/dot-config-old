"===============================================================================
" init.vim
" My cleaned up and documented config for neovim. If you like something you
" see then take it! Please don't copy this entire file, no one learns vim by
" using someone else's over-engineered setup :)
"
" Vim Compatibility
" This config is only intended to work for neovim. If I only have access to
" standard vim then I use a minimal config with the addition of the plugin
" 'tpope/vim-sensible'.
"
" Setup
" * Set `g:nvim_config_dir` and `g:nvim_data_dir` to appropriate values.
" * Run ':DownloadPlug' to download the vim-plug package manager.
" * Run ':PlugInstall' to fetch and install plugins.
" * Run ':CheckHealth' and make sure all checks are green. Install any missing
"   libraries needed for Ruby, Python2, and Python3 support.
" * FZF: Install Ag. If fzf can's find ag it falls back on grep, which is ok
"   but not as fast.
" * Neoformat: Install formatters for regularly used languages.
" * ALE: Install linters for regularly used languages. Use ':ALEInfo' on a file
"   to find out about linting that file type.
" * NVim-Completion-Manager: Install optional pip modules `mistune`, `psutil`,
"   and `setproctitle`. See ':h NCM-install'.
" * Gutentags: Install Universal Ctags, or disable gutentags.
"
" Documentation
" The goal is to over-document, so that this file can act not only as a
" configuration, but as a reference for learning/relearning vim features. I
" try to use a notation that is consistent with or at least inspired by the
" notation used in the vim docs, which is specified in ':help notation'.
" Special notation includes:
" * I use {c} to mean a single required character, and {*} to mean a single
"   character, restricted to the list immediately following.
" * When a key combination is specific to a mode or environment I preface it
"   with {EnvName}. The docs use {Visual}, but I've added {Insert}, {FZF},
"   {Magit}, etc.
"
"===============================================================================

" Base Directories -- nvim defines these in ':h base-directories', but doesn't
" provide variables to reference them with.
let g:nvim_config_dir = '~/.config/nvim'
let g:nvim_data_dir = '~/.local/share/nvim'

" Allow multibyte characters in this config. I don't think this is necessary
" in neovim, but it makes the vim linter 'vint' happy.
scriptencoding utf-8

" Make an autocmd group to use in this file. All autocmds should be bound to a
" group to prevents repeated autocmd execution when this config is sourced.
augroup vimrc
  autocmd!
augroup END


"===============================================================================
" Plugins
" Use vim-plug to manage plugins (https://github.com/junegunn/vim-plug)
" Manage with ':PlugInstall', ':PlugUpdate', ':PlugClean', and ':PlugUpgrade'.
"===============================================================================

call plug#begin(g:nvim_config_dir . '/plugged')

" Search and navigate with fuzzy find
" Open fzf in a terminal buffer, with values loaded in from different sources.
" Installs fzf locally to vim, instead or globally on the system.
" <Leader>a        fzf search with ag (search all text in project)
" <Leader>A        fzf search for word under cursor with ag
" <Leader>b        fzf search buffer list
" <Leader>e        fzf search all files under home dir
" <Leader>gc       fzf search git commits
" <Leader>gf       fzf search all files in current git repo (alias '<leader>p')
" <Leader>gh       fzf search git commits for buffer (buffer's git history)
" <Leader>gs       fzf search `git status`, meaning files with unstaged changes
" <Leader>h        fzf search recently opened files history
" <Leader>p        fzf search current project, meaning current git repo
" <Leader>z        fzf search ctags (ctag[z])
" <Leader>Z        fzf search helptags (helptag[Z])
" <Leader>/        fzf search current buffer
" <Leader>*        fzf search current buffer for text under cursor
" {FZF}<TAB>       select multiple results to open
" {FZF}<C-t>       open in new tab
" {FZF}<C-s>       open in horizontal split
" {FZF}<C-v>       open in vertical split
Plug 'junegunn/fzf', { 'dir': g:nvim_config_dir . '/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
\ }

" Formatting
" Find and run code formatters on buffer write.
" :Neoformat [formatter]             run formatting on the current buffer
" {Visual}:Neoformat [formatter]     run formatting on selection
Plug 'sbdchd/neoformat'
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
let g:neoformat_enabled_ruby = []
let g:neoformat_enabled_javascript = []
let g:neoformat_enabled_css = []
let g:neoformat_enabled_scss = []
autocmd vimrc BufWritePre * Neoformat

" Linting
" Find and run code linters on buffer write. Populates the location list with
" errors and warning for the current buffer. ALE will automatically find and
" use linters installed on your system, unless 'g:ale_linters' is set
" otherwise. ALE can be set to lint as you type, but I find that distracting.
" <Leader>i        linting info related to error on line
" :ALELint         manually run linters
" :ALEToggle       turn ALE on/off for current buffer
" :ALEDetail       show expanded message for error on line
" :ALEInfo         report available liners, settings, and linter log
Plug 'w0rp/ale'
let g:ale_linters = {
      \ 'typescript': ['tslint']
      \}
let g:ale_open_list = 0
let g:ale_list_window_size = 5
let g:ale_set_highlights = 1
let g:ale_set_signs = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_ruby_rubocop_options = '-c .rubocop_ci.yml'

" Toggle location and quickfix lists
" <Leader>l        toggle location list
" <Leader>q        toggle quickfix list
Plug 'Valloric/ListToggle'

" Completion
" Provides a dropdown menu with completion suggestions. The menu is populated
" with keywords from open vim buffers, project ctags, tmux panes, file paths,
" snippet plugins like Ultisnips, and NCM language specific plugins. NCM can
" be set to make suggestions as you type, but I prefer to call NCM manually
" with <TAB>.
" {Insert}<Tab>    open popup menu with completion suggestions
" {Insert}<S-Tab>  insert the tab character
" {Pmenu}<Tab>     scroll down through completion suggestions
" {Pmenu}<S-Tab>   scroll up through completion suggestions
Plug 'roxma/nvim-completion-manager'
let g:cm_auto_popup = 0

" Language Specific Completion
" Extensions to NCM for specific languages.
Plug 'Shougo/neco-syntax'        " parse vim syntax files for language keywords
Plug 'roxma/ncm-rct-complete'    " ruby via rcodetools, does not support rails
Plug 'calebeby/ncm-css'          " css, scss, sass, etc.
Plug 'roxma/ncm-elm-oracle'      " elm via elm-oracle
Plug 'roxma/nvim-cm-tern', {'do': 'npm install'}   " javascript via tern
Plug 'clojure-vim/async-clj-omni'  " clojure through nREPL

" Auto generate and manage ctags
" Requires some version of ctags, such as Exuberant Ctags or Universal Ctags.
" In order to generate tags Gutentags needs to know the root directory of the
" current project. If you use version management then the project root should
" be detected automatically. If you don't use version management then you'll
" have to read the docs. If the project uses Git or Mercurial then tags will
" only be generated for tracked files.
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_file_list_command = {
  \ 'markers': {'.git': 'git ls-files', '.hg': 'hg files'}
\ }

" Git integration
" Commands all start with ':G*'.
" gb               git blame in buffer
" <Leader>gb       git blame in buffer
" <Leader>gd       git diff on buffer
" <Leader>gs       git status display
Plug 'tpope/vim-fugitive'

" Browse Git history
" Relies on fugitive.
" :GV             view history for the current branch in a new tabpage
" :GV!            view history for the current file in a new tabpage
" :GV?            popuilate location list with file-specific commits
" gt              go to next tabpage
" gT              go to previous tabpage
Plug 'junegunn/gv.vim'

" Magit in vim
" special buffer for staging and committing chunks of code.
" :Magit           open magit buffer
" :MagitOnly       open magit buffer in current buffer
" gm               open magit buffer in current buffer
" <Leader>gm       open magit buffer in current buffer
" {Magit}?         view magit help
" {Magit}q         close magit buffer
" {Magit}R         refresh magit buffer
" {Magit}S         stage/unstage selection or chunk
" {Magit}L         stage/unstage line
" {Magit}CC        commit staged changes
" {Magit}CF        commit fixup to head and autosquash
" zo               open a fold
" zc               close a fold
" zi               toggle fold
Plug 'jreybert/vimagit'

" Simple file browser
" -                open file beagle in buffer directory
" {FileBeagle}+    add new file in directory
" {FileBeagle}q    return to buffer FB was called from
" {FileBeagle}<CR> go to directory/edit file under cursor
" show hidden files and dirs, suppress the default binding of <Leader>f
Plug 'jeetsukumaran/vim-filebeagle'
let g:filebeagle_show_hidden = 1
let g:filebeagle_suppress_keymaps = 1

" Test integration
" Run tests using the nvim terminal, with some extra conveniences provided by
" the neoterm plugin. Test runners can be defined per language/framework, as
" necessary.
" <Leader>tt       test this (run test under cursor)
" <Leader>tf       test file
" <Leader>ts       test suite
" <Leader>tl       test last
" <Leader>tg       test go (return to last ran test)
Plug 'janko-m/vim-test'
let g:test#strategy = 'neoterm'

" Better terminal integration
" Use neovim terminal to run tests with vim-test. Starts the terminal out
" small, use '<Leader>=' to resize windows for more space.
" <Leader><TAB>    toggle a terminal open/close
" <leader><ESC>    leave terminal mode and treat terminal as read-only buffer
" <Leader>RR       send the current line or visual selection to a REPL
" <Leader>RF       send the current file to a REPL
Plug 'kassio/neoterm'
let g:neoterm_size = 15
let g:neoterm_autoinsert = 1
let g:neoterm_use_relative_path = 1
let g:neoterm_repl_ruby = 'pry'

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
autocmd vimrc ColorScheme * hi! link Sneak Search
autocmd vimrc ColorScheme * hi! link SneakScope Visual

" Useful pairs of keybindings, toggle vim settings
" [b, [B, ]b, ]B   previous, first, next, last buffer
" [l, [L, ]l, ]L   previous, first, next, last local list entry
" [q, [Q, ]q, ]Q   previous, first, next, last quickfix list entry
" [t, [T, ]t, ]T   previous, first, next, last tag stack entry
" [y{motion}       encode string with c-style escape sequences
" ]y{motion}       decode string with c-style escape sequences
" [-space          insert [count] blank line(s) above
" ]-space          insert [count] blank line(s) below
" gl               swap line with line below, custom binding for ]e
" gL               swap line with line above, custom binding for [e
" coh              toggle hlsearch
" con              toggle line numbers
" cor              toggle relative line numbers
" cos              toggle spell check
" cow              toggle wrap
Plug 'tpope/vim-unimpaired'

" Make surround and unimpaired work with the "." repeat command
Plug 'tpope/vim-repeat'

" Unix file management integration
" Includes ':SudoEdit', ':SudoWrite', ':Move', ':Remove'.
Plug 'tpope/vim-eunuch'

" Better in-buffer search defaults
" Remove highlight after moving cursor, allow * search for selection.
" {Visual}*        search for selection forward
" {Visual}#        search for selection backward
Plug 'junegunn/vim-slash'

" Briefly highlight yanked text
Plug 'machakann/vim-highlightedyank'

" End syntax structures automatically
Plug 'tpope/vim-endwise'

" View and navigate the undo tree
" <Leader>u        toggle undo tree
" {Undotree}?      show hotkeys and quick help
Plug 'mbbill/undotree'
let g:undotree_SetFocusWhenToggle = 1

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

" Syntax/indent/compiler support
" Provides general functionality for many popular file types. Best used for
" languages that are rarely needed, or require no special functionality.
" Commonly used languages should be required separately and explicitly
" disabled for polyglot.
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = [
  \ 'elm',
  \ 'ruby',
  \ 'javascript',
  \ 'clojure'
\ ]

" Elm
" Integrate with elm tooling. These features require that the vim root
" directory is also the base directory of the elm project. If vim is opened
" from the elm project's 'src/' then elm-make and elm-oracle will fail.
" :ElmMake         compile the current file
" :ElmMakeMain     compile 'Main.elm'
" :ElmTest         run all tests, for specific files use vim-test
" :ElmFormat       run elm-format manually, instead of waiting for neoformat
" <LocalLeader>m   compile current file
" <LocalLeader>M   compile 'Main.elm'
" <LocalLeader>t   run all tests
" <LocalLeader>f   formal buffer
" <LocalLeader>d   shows the docs for the word under the cursor
" <LocalLeader>D   opens web browser to docs for the word under the cursor
Plug 'elmcast/elm-vim'
let g:elm_setup_keybindings = 0

" Ruby
Plug 'vim-ruby/vim-ruby'

" Rails
" Many different helper tools for rials apps. I only really use the navigation
" shortcuts.
" gf               go to rails file under cursor
" :Rpreview        open webpage for file
" :A               edit 'alternate' file (usually test)
" :R               edit 'related' file (depends)
" :E*              starts many commands for editing different types of files
Plug 'tpope/vim-rails'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'hotoo/jsgf.vim'
let g:javascript_plugin_flow = 1

" Clojure
"
Plug 'tpope/vim-fireplace'
Plug 'venantius/vim-cljfmt'

" ColorSchemes
" Some nice colorschemes, most of which require true color.
Plug 'iCyMind/NeoSolarized'
Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-two-firewatch'
Plug 'rakr/vim-colors-rakr'
Plug 'reedes/vim-colors-pencil'
Plug 'morhetz/gruvbox'

call plug#end()


"===============================================================================
" Theme & Statusline
" Picking a theme requires knowing the color pallet limits of your terminal
" emulator. Some terminals are limited to 16 or 256 colors, while 'true color'
" terminals have the full hex color range. Counterintuitive, true color
" terminals tend to set $TERM to 'xterm-256color', even though more than 256
" colors are available. Change the substring match on $TERM as needed to
" include/exclude regularly used terminals.
"
" I use something close to the default statusline, with the addition of
" indicating the current git branch (requires fugitive) and showing linting
" results (requires ALE).
"
" Also set the tabline that is visible when more than one tabpage is open. The
" default tabline tries to keep full file paths while abbreviating the path to
" save space. The result is hard to read, just use the file name instead.
"===============================================================================

if $TERM =~# 'xterm-256color' ||
 \ $TERM =~# 'screen-256color'      " true color terminals
  set termguicolors
  set background=dark
  colorscheme NeoSolarized
else                                " limited pallet terminals
  set background=light
  colorscheme my_theme_light
endif

set statusline=%<                         " truncate from start if necessary
set statusline+=%f                        " full filepath
set statusline+=%1(%)                     " padding
set statusline+=%h%q%w                    " tags: help, quickfix, preview
set statusline+=%m%r                      " tags: modified, read only
set statusline+=%([%{fugitive#head()}]%)  " git branch
set statusline+=%3(%)                     " padding
set statusline+=%{StatuslineALE()}        " ALE errors/warnings, if any exist
set statusline+=%=                        " right align
set statusline+=%12(%l,%c%)%5p%%          " line and col number, % through file

set tabline=%!MyTabLine()  " Build the tabline by iterating through the tab list


"===============================================================================
" Key Mappings (Vim ABCs)
" Common editing commands and motions, listed in alphabetical order. A number
" of keymaps have been added, and a few defaults have been changed. Notable
" changes to default behavior include:
"
" C{motion}        change text, do not save to register
" D{motion}        delete text, do not save to register
" H                left 3 columns
" J                down 3 lines
" K                up 3 lines
" L                right 3 columns
" Q                @q, execute the macro in register q
" U                redo
" x                delete char forward, don't save to register
" X                delete char backward, don't save to register
" Y                join two lines (Y looks like two lines joining into one)
" ;                enter command mode
" {Insert}<Tab>    open completion menu, or scroll down through menu
" {Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab
"===============================================================================

" a                insert after cursor
" A                insert at end of line
" <C-a>            increment number under cursor (pairs with <C-x>)

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
"   co|            toggle colorcolumn at column 81
noremap C "_c
noremap CC "_cc
nnoremap <silent> co<bar> :call <SID>ToggleColorColumn()<CR>

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

" g{*}             misc/variant actions
"   gc{motion}     toggle commenting on lines that {motion} moves over
"   gcc            comment/uncomment line
"   gf             edit rails file under cursor (vim-rails)
"   gf             edit file at filepath under cursor
"   gg             jump to start of file, or line N
"   gj             down through a wrapped text line
"   gk             up through a wrapped text line
"   gl             swap current line with line [count] below
"   gL             swap current line with line [count] above
"   gp             paste from system clipboard, move cursor to end of pasted
"   {Visual}gp     paste from system clipboard over selection, move to end
"   gP             paste from system clipboard, put text before cursor
"   gq             reformat/wrap text
"   gs             give spelling suggestions
"   gt             go to the next tabpage
"   gT             go to the previous tabpage
"   gu             lowercase
"   gU             uppercase
"   gv             re-select last visual selection
"   gy             yank to system clipboard
"   {Visual}gy     yank selection to system clipboard
"   gz             center window on cursor line
"   g?             rot13 selection/motion
" G                jump to end of file
nnoremap gb :Gblame<CR>
nmap gl v_]e
nmap gL v_[e
nnoremap gm :MagitOnly<CR>
noremap <silent> gp "+p`]
noremap gP "+P
nnoremap gs z=
nmap gy "+y
vnoremap <silent> gy "+y`]
noremap gz zz

" h                left
" H                left 3 columns
" <A-h>            previous buffer
" {Term}<A-h>      previous buffer
" <C-h>            focus window left
" {Term}<C-h>      focus window left
nnoremap H hhh
nnoremap <A-h> :bprevious<CR>
tnoremap <A-h> <C-\><C-n>:bprevious<CR>
nnoremap <C-h> <C-w>h
tnoremap <C-h> <C-\><C-n><C-w>h

" i                insert before cursor
" I                insert at beginning of line
" {VisualBlock}I   insert at beginning of each line in selection

" j                down
" J                down 3 lines
" <C-j>            focus window below
" {Term}<C-j>      focus window below
nnoremap J jjj
vnoremap J jjj
nnoremap <C-j> <C-w>j
tnoremap <C-j> <C-\><C-n><C-w>j

" k                up
" K                up 3 lines
" <C-k>            focus window above
" {Term}<C-k>      focus window above
" {Insert}<C-k>    insert a diagraph (e.g. 'e' + ':' = 'ë')
nnoremap K kkk
vnoremap K kkk
nnoremap <C-k> <C-w>k
tnoremap <C-k> <C-\><C-n><C-w>k

" l                right
" L                right 3 columns
" <A-l>            next buffer
" {Term}<A-l>      next buffer
" <C-l>            focus window right
" {Insert}<C-l>    focus window right, leave insert mode
" {Term}<C-l>      focus window right
nnoremap L lll
nnoremap <A-l> :bnext<CR>
tnoremap <A-l> <C-\><C-n>:bnext<CR>
nnoremap <C-l> <C-w>l
inoremap <C-l> <ESC><C-w>l
tnoremap <C-l> <C-\><C-n><C-w>l

" m{a-Z}           set mark char, where a-z marks in buffer, A-Z cross-buffers
" M                jump middle, move cursor to middle line
" mm               set mark M (jump with <Leader>m)
" mn               set mark N (jump with <Leader>n)
noremap mm mM
noremap mn mN

" n                jump to next search result
" N                jump to previous search result

" o                insert line below cursor
" O                insert line above cursor
" {Insert}<C-o>    execute one command then return to insert mode

" p                put/paste after cursor, place cursor at end of pasted text
" {Visual}p        put/paste over selection, place cursor at end of pasted text
" P                paste before cursor
noremap <silent> p p`]

" q{c}             record macro to register {c}
" @{c}             run macro from register {c}
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
" {Insert}<C-v>    insert a character literal (e.g. <TAB> instead of 2 spaces)

" w                move word forward
" W                move WORD forward

" x                delete char forward, don't save to register
" X                delete char backward, don't save to register
" <C-x>            decrement number under cursor (pairs with <C-a>)
noremap x "_x
noremap X "_X

" y                yank/copy text
" {Visual}y        yank selection, place cursor at end of selection
" Y                join two lines (Y looks like two lines joining into one)
map y <Plug>(highlightedyank)
vnoremap <silent> y y`]
noremap Y J

" z{*}             manage folds
"   zc             close fold
"   zd             delete fold
"   zf             create fold with motion
"   zi             toggle all folds in buffer
"   zo             open fold
" zz               center window on cursor
" ZZ               save and exit
" <C-z>            suspend program

" [{*}             back list entry actions
"   [b, [B         previous, first buffer
"   [l, [L         previous, first location list entry
"   [q, [Q         previous, first quickfix list entry
"   [t, [T         previous, first tag stack entry
"   [s             previous misspelled word
"   [e             previous change list entry
" ]{*}             forward list entry actions
"   ]b, ]B         next, last buffer
"   ]l, ]L         next, last location list entry
"   ]q, ]Q         next, last quickfix list entry
"   ]t, ]T         next, last tag stack entry
"   ]s             next misspelled word
"   ]e             next change list entry
" [y{motion}       encode string with c-style escape sequences
" ]y{motion}       decode string with c-style escape sequences
" [<space>         insert [count] blank line(s) above
" ]<space>         insert [count] blank line(s) below
" <A-[>            previous jump list location
" <A-]>            next jump list location
" <C-]>            follow ctag
" <C-[>            <ESC>
nnoremap [e g;
nnoremap ]e g,
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

" >>               indent line
" {Visual}>        indent selection
" <<               un-indent line
" {Visual}<        un-indent selection
" ==               auto indent
" {Visual}=        auto indent selection

" "{r}{y/d/c/p}    use register {r} for next yank, delete, or paste
" "{r}{y/d/c/p}    store text to register {r} for next yank or delete
" ""               default register, '""y' is equivalent to 'y'
" "{a-z}           named registers for manual use
" "_               black hole/trash register
" ".               contains last inserted text
" "%               contains name of current file
" "#               contains name of alternate file
" ":               contains most recently executed command
" "/               contains last search

" '{a-Z}           jump to mark {a-Z}, start of line
" `{a-Z}           jump to mark {a-Z}, line and column position

" .                repeat last command
" {Visual}.        repeat last command once on each line
vnoremap . :norm.<CR>

" -                open file beagle in buffer directory
" {FileBeagle}+    edit new file in directory
" {FileBeagle}q    return to buffer FB was called from
" {FileBeagle}<CR> go to directoy/edit file under cursor
nnoremap - :FileBeagleBufferDir<CR>
command! -nargs=+ -complete=file -bar FBMakeDir :Mkdir <args>|call feedkeys("R")
autocmd vimrc FileType filebeagle nmap _ :FBMakeDir

" <Tab>            indent line/selection
" <S-Tab>          un-indent line/selection
" {Insert}<Tab>    show completion menu, scroll down through menu
" {Insert}<S-Tab>  if the completion menu is open scroll up, else insert a tab
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >
vnoremap <S-Tab> <
imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Plug>(cm_force_refresh)"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"


"===============================================================================
" Leader Bindings
" General convenience bindings -- search and navigation with fzf, git
" integration with fugitiveand magit, window management, useful odds and ends.
"===============================================================================

" Leader
let g:mapleader = "\<Space>"

" <Leader>a  fzf search with ag (search all text in project)
" <Leader>A  fzf search word under cursor with ag
nnoremap <silent> <Leader>a :Ag<CR>
nnoremap <silent> <Leader>A :Ag <CR><C-R><C-W>

" <Leader>b  fzf search buffer list
nnoremap <silent> <Leader>b :Buffers<CR>

" <Leader>c  close focused window
nnoremap <Leader>c <C-w><C-q>

" <Leader>d  delete this buffer from buffer list, keep window if possible
nnoremap <Leader>d :bp<bar>sp<bar>bn<bar>bd<CR>

" <Leader>e  edit any file, fzf search all files under home (except hidden dirs)
nnoremap <silent> <Leader>e :Files ~<CR>

" <Leader>f  TODO

" <Leader>g{*}  git bindings
"   <Leader>gb  fugitive git blame
"   <Leader>gc  fzf search git commits
"   <Leader>gd  fugitive git diff
"   <Leader>gh  fzf search git commits for buffer (buffer's git history)
"   <Leader>gm  open magit
"   <Leader>gf  fzf search all files in current git repo
"   <Leader>gs  fzf search `git status`, meaning files with unstaged changes
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gc :Commits<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gh :BCommits<CR>
nnoremap <silent> <Leader>gm :MagitOnly<CR>
nnoremap <silent> <Leader>gf :GFiles<CR>
nnoremap <silent> <Leader>gs :GFiles?<CR>

" <Leader>h  fzf search recently opened files history
" <Leader>H  swap window left
nnoremap <silent> <Leader>h :History<CR>
nnoremap <Leader>H <C-w>H

" <Leader>i  linting info related to error on line
" <Leader>I  show vim syntax highlighting groups for word under cursor
nnoremap <Leader>i :ALEDetail<CR>
nnoremap <Leader>I :call <SID>SynStack()<CR>

" <Leader>j  TODO
" <Leader>J  swap window down
nnoremap <Leader>J <C-w>J

" <Leader>k  TODO
" <Leader>K  swap window up
nnoremap <Leader>K <C-w>K

" <Leader>l  toggle location list, using ListToggle plugin
" <Leader>L  swap window right
nnoremap <Leader>L <C-w>L

" <Leader>m  jump to mark M
nnoremap <Leader>m 'M

" <Leader>n  jump to mark N
nnoremap <Leader>n 'N

" <Leader>o  TODO

" <Leader>p  fzf search current project, meaning current git repo
nnoremap <silent> <Leader>p :GFiles<CR>

" <Leader>q  toggle the quickfix list, using ListToggle plugin

" <Leader>r             TODO
" <Leader>R{*}          neoterm REPL
"   <Leader>RR          send the current line to a REPL
"   {Visual}<Leader>RR  send selection to a REPL
"   <Leader>RF          send the current file to a REPL
nnoremap <Leader>RR :TREPLSendLine<CR>
vnoremap <Leader>RR :TREPLSendSelection<CR>
nnoremap <Leader>RF :TREPLSendFile<CR>

" <Leader>s  TODO

" <Leader>t{*}  test bindings
"   <Leader>tt  test this (run test under cursor)
"   <Leader>tf  test file
"   <Leader>ts  test suite
"   <Leader>tl  test last
"   <Leader>tg  test go (return to last ran test)
nnoremap <silent> <leader>tt :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tg :TestVisit<CR>

" <Leader>u  toggle undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" <Leader>v  vertical split
" <Leader>V  horizontal split
noremap <Leader>v :vsplit<CR>
noremap <Leader>V :split<CR>

" <Leader>w         wrap/reformat the current line
" {Visual}<Leader>w wrap/reformat selection
nnoremap <Leader>w gqq
vnoremap <Leader>w gq

" <Leader>x  TODO

" <Leader>y{c}  surround a word with {c} (weak mnemonic is You surround word)
" <Leader>Y{c}  surround a WORD with {c}
nnoremap <Leader>y <ESC>:execute "normal \<Plug>Ysurround"<CR>g@iw
nnoremap <Leader>Y <ESC>:execute "normal \<Plug>Ysurround"<CR>g@iW

" <Leader>z  fzf search ctags (ctag[z])
" <Leader>Z  fzf search helptags (helptag[Z])
nnoremap <silent> <Leader>z :Tags<CR>
nnoremap <silent> <Leader>Z :Helptags<CR>

" <Leader>=  resize windows to split evenly
nnoremap <Leader>= <C-w>=

" <Leader>|  vertical split
" <Leader>_  horizontal split
noremap <Leader><Bar> :vsplit<CR>
noremap <Leader>_ :split<CR>

" <Leader>/  fzf search current buffer
" <Leader>*  fzf search current buffer for text under cursor
nnoremap <Leader>/ :BLines<CR>
nnoremap <Leader>* :BLines <C-r><C-w><CR>

" <Leader><Leader>  switch between current and last buffer
nnoremap <Leader><Leader> <c-^>

" <Leader><TAB>        toggle a terminal open/close
" {Term}<Leader><TAB>  toggle a terminal open/close
nnoremap <leader><TAB> :Ttoggle<CR>
tnoremap <leader><TAB> <C-\><C-n>:Ttoggle<CR>

" {Term}<Leader><ESC>  switch from terminal mode to reading terminal as buffer
tnoremap <Leader><ESC> <C-\><C-n>


"===============================================================================
" Local Leader Bindings
" Bindings for specific file types.
"===============================================================================

let g:maplocalleader = ','

" Elm
" These commands require that the vim root directory is also the base
" directory of the elm project. If vim is opened from 'src/' then elm-make and
" elm-oracle will fail.
" <LocalLeader>m  compile current buffer
" <LocalLeader>M  compile project
" <LocalLeader>t  run tests (TODO: how is this different from vim-test?)
" <LocalLeader>f  format file
" <LocalLeader>d  shows the docs for the word under the cursor
" <LocalLeader>D  opens web browser to docs for the word under the cursor
autocmd vimrc FileType elm nmap <LocalLeader>m <Plug>(elm-make)
autocmd vimrc FileType elm nmap <LocalLeader>M <Plug>(elm-make-main)
autocmd vimrc FileType elm nmap <LocalLeader>t <Plug>(elm-test)
autocmd vimrc FileType elm nmap <LocalLeader>f :ElmFormat<CR>
autocmd vimrc FileType elm nmap <LocalLeader>d <Plug>(elm-show-docs)
autocmd vimrc FileType elm nmap <LocalLeader>D <Plug>(elm-browse-docs)

" Clojure
" <LocalLeader>r  require the current namespace so it's updated in the nREPL
" <LocalLeader>R  require the current namespace with the :reload-all flag
" <LocalLeader>e  evaluate the innermost form under cursor
" <LocalLeader>E  evaluate the outermost form under cursor
" <LocalLeader>f  format file
" <LocalLeader>d  show docs for token under cursor
" <LocalLeader>s  show source for token under cursor
autocmd vimrc FileType clojure nmap <LocalLeader>r :Require<CR>
autocmd vimrc FileType clojure nmap <LocalLeader>R :Require!<CR>
autocmd vimrc FileType clojure nmap <LocalLeader>e cpp
autocmd vimrc FileType clojure nmap <LocalLeader>E :Eval<CR>
autocmd vimrc FileType clojure nmap <LocalLeader>f :Cljfmt<CR>
autocmd vimrc FileType clojure nmap <LocalLeader>d :Doc <C-r><C-w><CR>
autocmd vimrc FileType clojure nmap <LocalLeader>s :Source <C-r><C-w><CR>


"===============================================================================
" Text Objects
"===============================================================================

" i{*}             inner/inside text object
" a{*}             a/all of text object, includes surrounding whitespace
"   c              comment
"   e              entire buffer
"   l              line
"   p              paragraph
"   s              sentence
"   t              html tags
"   v              variable segment, either snake_case or camelCase
"   w              word
"   W              WORD
"   [ or ], ( or ),
"   < or >, { or } matching pairs
"   `, ", '        matching quotes


"===============================================================================
" Commands
" Functions that I don't use enough to motivate key bindings.
"===============================================================================

" Highlight the color column, defaults to col 81 if nothing else is set
command! TCC call <SID>ToggleColorColumn()

" Download the vim-plug package manager
command! DownloadPlug call <SID>DownloadPlug()

" Plug starts with ':Plug*', includes Install, Clean, Update, Upgrade.

" Git starts with ':G*', includes blame, diff. Use ':GV' to view git history.

" Unix utilities include ':SudoEdit', ':SudoWrite', ':Move', and ':Remove'.

" Rails
" ':Rpreview' open webpage, ':A' edit 'alternate' file (usually test)
" ':R' edit 'related' file (depends), editing specific files starts with ':E*'

" Linting starts with ':ALE*', includes Lint, Toggle, Detail, Info.


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
set nojoinspaces             " prevents inserting two spaces on a join (Y)
set ignorecase               " make searching case insensitive...
set smartcase                " ... unless the query has capital letters
set nowrap                   " don't wrap text, use 'cow' to toggle line wrap
set list                     " highlight tabs and trailing spaces
set listchars=tab:>·,trail:· " symbols to display for tabs and trailing spaces
set scrolloff=3              " show next 3 lines while scrolling
set sidescrolloff=5          " show next 5 columns while side-scrolling
set splitbelow               " horizontal split opens under active window
set splitright               " vertical split opens to right of active window
set shortmess+=I             " Don't show the intro
set bufhidden=hide           " allow switching from an unsaved buffer
set autowrite                " auto write file when switching buffers
set wildmode=longest:full    " bash-style command mode completion
set fillchars=vert:\│        " use unicode box drawing char to divide windows


"===============================================================================
" Metadata Files
" In general neovim stores metadata files in '$XDG_DATA_HOME/nvim/*', which
" most likely resolves to '~/.local/share/nvim/*'.
"===============================================================================

" don't save file backups, but if backups are saved, don't co-locate them with
" the original file, use '~/.local/share/nvim/backup//' instead
set nobackup
set backupdir-=.
" unlike with swap, undo, and shada, nvim won't auto-mkdir for backups
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), 'p')
endif

" save swap files to '~/.local/share/nvim/swap//'
set swapfile

" save undo history files to '~/.local/share/nvim/undo//'
set undofile

" Use the default setting for the shada (shared data) file. See ':h 'shada''
" for details. Saves to '~/.local/share/nvim/shada/main.shada'.


"===============================================================================
" Filetype Settings
" Most filetypes are dealt with by plugins, here's what's left.
"===============================================================================

" text: wrap at 80 characters
autocmd vimrc FileType text setlocal textwidth=80
autocmd vimrc FileType markdown setlocal textwidth=80

" vim: reload vimrc every time this buffer is saved
autocmd vimrc BufWritePost $MYVIMRC source $MYVIMRC

" elm: use 4 spaces to indent
autocmd vimrc FileType elm setlocal tabstop=4
autocmd vimrc FileType elm setlocal shiftwidth=4


"===============================================================================
" Helper Functions
" Hide these at the bottom. :)
"===============================================================================

" download the vim-plug package manager
function! <SID>DownloadPlug()
  let l:dir = glob(g:nvim_config_dir . '/autoload/plug.vim')
  if empty(l:dir)
    !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo 'Plug downloaded to ' . l:dir
  else
    echo 'Plug is already downloaded to ' . l:dir
  endif
endfunction

" vim theme building helper
function! <SID>SynStack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), "synIDattr(v:val, 'name')")
endfunc

function! <SID>ToggleColorColumn()
  if &colorcolumn !=? ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=81
  endif
endfunc

function! StatuslineALE()
  let l:issues = ale#statusline#Count(bufnr('%'))
  if l:issues.total > 0
    if l:issues.error > 0
      return 'ERRORS: ' . l:issues.error
    elseif l:issues.warning > 0
      return 'WARNINGS: ' . l:issues.warning
    elseif (l:issues.style_error + l:issues.style_warning) > 0
      return 'STYLE: ' . (l:issues.style_error + l:issues.style_warning)
    elseif l:issues.info > 0
      return 'INFO: ' . l:issues.info
    endif
  endif

  return ''
endfunction

function! MyTabLine()
  let l:s = ''
  for l:i in range(tabpagenr('$'))
    " highlight the open tabpage
    if l:i + 1 == tabpagenr()
      let l:s .= '%#TabLineSel#'
    else
      let l:s .= '%#TabLine#'
    endif

    " list the filename of the selected window in each tabpage
    let l:s .= '  %{MyTabLabel(' . (l:i + 1) . ')}  '
  endfor

  " after the last tabpage blank out the rest of the line
  let l:s .= '%#TabLineFill#'

  return l:s
endfunction

function! MyTabLabel(n)
  let l:buflist = tabpagebuflist(a:n)
  let l:winnr = tabpagewinnr(a:n)
  return fnamemodify(bufname(l:buflist[l:winnr - 1]), ':t')
endfunction
