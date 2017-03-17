
" Git syntax/nice defaults
Plug 'tpope/vim-git'

" Git integration
" Commands all start with ":G".
" gb               git blame in buffer (I use this a lot)
" <Leader>gb       git blame in buffer
" <Leader>gd       git diff on buffer
" <Leader>gs       git status display
Plug 'tpope/vim-fugitive'

" Magit in vim
" special buffer for staging and committing chunks of code.
" :Magit           open magit buffer
" <Leader>gm       open magit buffer
" {Magit}?         view magit help
" zo               open a fold
" zc               close a fold
Plug 'jreybert/vimagit'

" Rails navigation
" Misc helpers for navigating rails apps.
" TODO: create way to cycle between related files
" gf               edit file under cursor
" ":Rpreview"      open webpage for file
" ":A"             edit 'alternate' file (usually test)
" ":R"             edit 'related' file (depends)
" ":E*"            starts many commands for editing different types of files
Plug 'tpope/vim-rails'

" Program linting
" Run linters asynchronously, populate the location list with errors.
" TODO: Find a better solution than highlighting lines
" TODO: add elixir, javascript, coffeescript, erb, elm
Plug 'neomake/neomake'
autocmd! BufWritePost * Neomake
let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']
let g:neomake_ruby_rubocop_maker = { 'args': ['-c', '.rubocop_ci.yml'] }
let g:neomake_place_signs = 0
let g:neomake_verbose = 1
let g:neomake_highlight_lines = 1
augroup my_neomake_highlights
  au!
  autocmd ColorScheme *
        \ hi link NeomakeError SpellBad |
        \ hi link NeomakeWarning SpellCap
augroup END


" Better terminal integration
" Use neovim terminal to run tests with vim-test. Starts the terminal out
" small, use '<Leader>=' to resize windows for more space.
" <Leader><tab>    toggle a terminal open/close
" <Leader>RR       send the current line or visual selection to a REPL
" <Leader>RF       send the current file to a REPL
Plug 'kassio/neoterm'
let g:neoterm_size = 15
let g:neoterm_autoinsert = 1
let g:neoterm_use_relative_path = 1
let g:neoterm_repl_ruby = 'pry'

" Test integration
" For my current rails project all tests go through a hacked version of 'm',
" but in general I wouldn't want to override the test executables.
" <Leader>tt       test this (run test under cursor)
" <Leader>tf       test file
" <Leader>ts       test suite
" <Leader>tl       test last
" <Leader>tg       test go (return to last ran test)
Plug 'janko-m/vim-test'
let test#strategy = "neoterm"
let g:test#ruby#rspec#executable = 'm'
let g:test#ruby#minitest#executable = 'm'

" Elm
" Run elm-format after saving a buffer. Uses the local leader "," for
" langauage specific bindings.
Plug 'elmcast/elm-vim'
let g:elm_setup_keybindings = 0
let g:elm_format_autosave = 1
" <LocalLeader>d  shows the docs for the word under the cursor
" <LocalLeader>D  opens web browser to docs for the word under the cursor
" <LocalLeader>e  shows details for error selected in quickfix menu
" <LocalLeader>m  compiles current buffer
let g:polyglot_disabled = ['elm']


" Autocomplete menu
" I don't like getting suggestions all the time, so I disable the autocomplete
" feature, and call deplete manually with tab. This overrides the tab key in
" insert mode.
" {Instert}<Tab>  show popup menu with completion suggestions
" {Pmenu}<Tab>    scroll through completion suggestions
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#disable_auto_complete = 1
let g:deoplete#enable_ignore_case = 0
let g:deoplete#tag#cache_limit_size = 5000000
let g:deoplete#sources = {}
let g:deoplete#sources._ = ['buffer', 'tag', 'omni']


" Auto generate and manage ctags
Plug 'ludovicchabant/vim-gutentags'


