" Environment {{{1

" vint:next-line -ProhibitSetNoCompatible
set nocompatible

nnoremap <space> <nop>
let mapleader = ' '

if has('win32')
    let $DOTVIM = expand('$HOME/vimfiles')
    let $MYREALVIMRC = expand('$HOME/_vimrc')
else
    let $DOTVIM = expand('$HOME/.vim')
    let $MYREALVIMRC = expand('$HOME/.vimrc')
endif

" Plugins {{{1

" Prefix {{{2

call plug#begin('$DOTVIM/plugged')

" Conditional activation for vim-plug plugins
" https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Basics {{{2

Plug 'chriskempson/base16-vim'
Plug 'daviesjamie/vim-base16-lightline'

Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'sjl/gundo.vim'
Plug 'vim-scripts/dbext.vim'

Plug 'easymotion/vim-easymotion'
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'edkolev/tmuxline.vim'

Plug 'niklaas/lightline-gitdiff', Cond(!isdirectory(expand('$HOME/git/lightline-gitdiff')))
Plug '$HOME/git/lightline-gitdiff', Cond(isdirectory(expand('$HOME/git/lightline-gitdiff')), { 'as': 'lightline-gitdiff-local' })

Plug 'tpope/vim-abolish'  " for better substitution
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'  " sugar for UNIX shell commands
Plug 'tpope/vim-obsession'  " for session management
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'  " e.g. map zS for showing syntax group
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'  " for auto-indenting
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'  " for better netrw
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'  " fugitive GitHub integration
Plug 'tpope/vim-projectionist'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'w0rp/ale', Cond(v:version >= 800)

Plug 'sheerun/vim-polyglot'

" Test framework for development
Plug 'junegunn/vader.vim'

call plug#end()

" Vim extensions {{{2

" allows displaying of man pages with :Man <program>
runtime! ftplugin/man.vim

" Vim settings {{{1

set autowrite
set backspace=indent,eol,start
set clipboard+=unnamed
set cpoptions+=$
set gdefault
set hidden
set ignorecase
set incsearch
set linebreak
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set modelines=5
set mouse=a
set nobackup
set nohlsearch
set nojoinspaces
set noshowmode
set nowrap
set nowritebackup
set number
set pumheight=10
set relativenumber
set ruler
set shortmess=catOT
set showbreak=+
set showmatch
set signcolumn=yes
set smartcase
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tags=./tags,./TAGS,tags,TAGS,../tags,../../tags,../../../tags,../../../../tags
set termguicolors
set undofile
set updatetime=300
set viminfo=%,'50,:100,<1000
set visualbell
set whichwrap=b,s
set wildignorecase
set wildmenu

" Set locations of important directories
set backupdir=$DOTVIM/backup/
set directory=$DOTVIM/swap/,.
set undodir=$DOTVIM/undo

" Always show status line
set laststatus=2
set showtabline=1

" Encoding and file format
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileformat=unix
set fileformats=unix,dos

" Indenting
set shiftround
set expandtab smarttab autoindent smartindent
set tabstop=2 shiftwidth=2 softtabstop=2

" Spelling
set spelllang=en_us,de_20
set spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/de.utf-8.add

" Grepping
if executable('rg')
  set grepprg=rg\ --vimgrep
endif

augroup responsive_cursorline
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup end

" colorscheme
function! s:read_background() abort
  source ~/.vimrc_background
endfunction
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  call s:read_background()
endif

if has('gui_running')
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
  set lines=50
  set columns=120
  if has('gui_gtk2')
    set guifont=Monospace\ 11
    set background=dark
  elseif has('gui_win32')
    set guifont=Consolas:h10:cANSI
  endif
endif

highlight CursorLineNr cterm=none

" Plugin Configuration {{{1

" vista {{{2
let g:vista_close_on_jump = 0
let g:vista#renderer#enable_icon = 1
let g:vista_echo_cursor = 0

" dbext
let g:dbext_default_usermaps = 0
 
" Lightline {{{2

" TODO: indicate all buffers that start with fugitive://* b/c handy when
" comparing 'real file' with git diff.

let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
      \ 'inactive': {
      \   'left': [ [ 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \            [ 'percent' ] ]
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ],
      \             [ 'gitdiff' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ],
      \              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]
      \            ]
      \ },
      \ 'component_function': {
      \   'obsession': 'LightlineObsession',
      \   'cwd': 'Cwd',
      \   'gitbranch': 'GitBranch',
      \   'fileformat': 'LightlineFileformat',
      \   'fileencoding': 'LightlineFileencoding',
      \   'filetype': 'LightlineFiletype',
      \ },
      \ 'component_expand': {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \   'gitdiff': 'lightline#gitdiff#get',
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_checking': 'middle',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'middle',
      \ },
      \ 'tabline': {
      \   'right': [  ]
      \ },
      \ 'mode_map': {
      \   'n' : 'N',
      \   'i' : 'I',
      \   'R' : 'R',
      \   'v' : 'V',
      \   'V' : 'VL',
      \   "\<C-v>": 'VB',
      \   'c' : 'C',
      \   's' : 'S',
      \   'S' : 'SL',
      \   "\<C-s>": 'SB',
      \   't': 'T',
      \ },
      \ }

let g:lightline#ale#indicator_checking = '...'

function! LightlineObsession()
  let l:status = strpart(ObsessionStatus(), 1, 1)
  return l:status ==# '$' ? '$' : ''
endfunction

function! GitBranch()
  let l:head = FugitiveHead()
  return len(l:head) > 0 ? ' ' . FugitiveHead() : ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 140 ? &fileformat : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 140 ? &fileencoding : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 140 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! Cwd()
  " TODO: splitting does not work on Windows with '\'
  let root_dir_as_list = split(getcwd(), '/')[-1:]

  if len(root_dir_as_list) ==# 1
    return root_dir_as_list[0]
  endif

  return ''
endfunction

" tmux navigator
if !exists('$TMUX')
  " I do not want to override <c-{h,j,k,l}> b/c e.g., <c-{h,j}> are quite
  " handy for not having to reach <bs> and <cr>.
  let g:tmux_navigator_no_mappings = 1
endif

" Tmuxline {{{2
let g:tmuxline_powerline_separators = 0
let g:tmuxline_theme = 'lightline'
let g:tmuxline_preset = 'minimal'

" Editorconfig {{{2
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Projectionist {{{2
let g:projectionist_heuristics = json_decode(join(readfile(expand($DOTVIM . '/misc/projections.json'))))

" ALE {{{2
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \   'typescript': ['eslint'],
      \   'scss': ['stylelint'],
      \   'vim': ['vint'],
      \   'zsh': ['shell', 'shellcheck'],
      \   'terraform': ['terraform']
      \ }
let g:ale_fixers = {
      \   'html': [ 'prettier'],
      \   'javascript': [ 'prettier', 'eslint', 'trim_whitespace' ],
      \   'typescript': [ 'prettier', 'eslint', 'trim_whitespace' ],
      \   'typescriptreact': [ 'prettier' ],
      \   'json': [ 'prettier' ],
      \   'zsh': [ 'trim_whitespace' ],
      \   'terraform': ['terraform'],
      \   'scss': ['prettier'],
      \   'markdown': ['prettier'],
      \   '*': ['remove_trailing_lines']
      \ }

let g:ale_fix_on_save = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 7

let g:ale_javascript_eslint_suppress_missing_config = 1

let g:ale_set_highlights = 1
let g:ale_set_signs = 1
let g:ale_sign_warning = '?'
let g:ale_sign_error = '!'
let g:ale_sign_info = 'o'

" Mappings {{{1

" homerow  et al {{{2

nmap      <silent>          <leader>d    :ALEDetail<cr>
nmap                        <leader>F    <Plug>(ale_fix)
nnoremap <silent>           <leader>l    :Vista!!<cr>

nnoremap                  ga :edit %<.

" General {{{2

nnoremap <silent> <c-[> :w<cr>

" Allows incsearch highlighting for range commands
"
" For example, search for 'foo' upwards from cursor and move it to the
" current position of the cursor:
"
"   ?foo$m
"
cnoremap $t <CR>:t''<CR>
cnoremap $m <CR>:m''<CR>
cnoremap $d <CR>:d<CR>``

nnoremap Y y$
nnoremap gb :ls<CR>:b<space>

" Yanks current outer paragraph and pastes above
nnoremap <leader>p yapP

inoremap <c-o> <esc>O

" Plugin related {{{2

" fugitive
nnoremap <leader>gg :Git<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>ga :Git blame<cr>
nnoremap <leader>gB :.Git blame<cr>
nnoremap <leader>gc :Git commit --quiet<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gp :Git pull<cr>
nnoremap <leader>gP :Git push<cr>
nnoremap <leader>gr :GBrowse<space>
xnoremap <leader>gr :GBrowse<space>

" ALE
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)

nnoremap <leader>r :%S/<C-r><C-w>/<C-r><C-w>/w<left><left>

" Commands {{{1

command! BD :bp\|bd #<cr>
command! BW :bp\|bw #<cr>

command! CD :cd %:p:h<CR>:pwd<CR>

command! YankFullPath :let @+ = expand("%")
command! YankFilename :let @+ = expand("%:t")
command! YankFullPathLC :let @+ = expand("%")   . ':' . line('.') . ':' . col('.')
command! YankFilenameLC :let @+ = expand("%:t") . ':' . line('.') . ':' . col('.')

" Abbreviations {{{1

" Expand %% to the current directory
cabbrev <expr> %% expand('%:p:h')

" autocmds {{{1

" Filetype-specific autocmds {{{2
"
" This section includes autocomds that change settings and add mappings
" depending on the filetype of the current plugin.

augroup filename_MERGEREQU_EDITMSG
  autocmd!
  autocmd BufEnter MERGEREQ_EDITMSG set filetype=gitcommit
augroup END

augroup filetype_gitcommit
  autocmd!
  autocmd FileType gitcommit setlocal comments+=fb:- fo+=nrbl spell
augroup END

augroup filetype_html
  autocmd!
  autocmd FileType html setlocal foldmethod=indent | normal zR
augroup END

augroup filetype_netrw
  autocmd!
  autocmd FileType netrw setlocal bufhidden=delete
augroup END

augroup filetype_markdown
  autocmd!
  autocmd FileType markdown setlocal comments=b:>,fb:-,fb:*,fb:-\ [\ ],fb:-> textwidth=80 fo+=c
  " The following fixes additional indentation in the subsequent lines of
  " lists
  "
  " https://github.com/plasticboy/vim-markdown/issues/126#issuecomment-485579068
  autocmd FileType markdown setlocal indentexpr=
augroup END

augroup filetype_nunjucks
  autocmd!
  autocmd BufRead,BufNewFile *.njk set ft=jinja
augroup END

augroup filetype_sql
  autocmd!
  autocmd FileType sql let &l:formatprg = 'python -m sqlparse -k upper -r --indent_width 2 -'
augroup end

augroup filetype_typescript
  autocmd!
  autocmd FileType typescript let b:ale_javascript_prettier_options = '--parser typescript'
augroup END

augroup filetype_vimrc
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" Miscellaneous {{{1

function! s:ftplugin_fugitive() abort
  nnoremap <buffer> <silent> cc :Git commit --quiet<CR>
  nnoremap <buffer> <silent> ca :Git commit --quiet --amend<CR>
  nnoremap <buffer> <silent> ce :Git commit --quiet --amend --no-edit<CR>
endfunction
augroup fugitive_quiet
  autocmd!
  autocmd FileType fugitive call s:ftplugin_fugitive()
augroup END

" Fix highlighting for spell and other highlight groups in terminal
function! s:base16_customize() abort
  " Colors: https://github.com/chriskempson/base16/blob/master/styling.md
  " Arguments: group, guifg, guibg, ctermfg, ctermbg, attr, guisp
  call Base16hi('SpellBad',   g:base16_gui08, 'NONE', g:base16_cterm08, 'NONE', '', '')
  call Base16hi('SpellCap',   g:base16_gui0A, 'NONE', g:base16_cterm0A, 'NONE', '', '')
  call Base16hi('SpellLocal', g:base16_gui0D, 'NONE', g:base16_cterm0D, 'NONE', '', '')
  call Base16hi('SpellRare',  g:base16_gui0B, 'NONE', g:base16_cterm0B, 'NONE', '', '')
  call Base16hi('MatchParen', g:base16_gui0E, 'NONE', g:base16_cterm0E, 'NONE', '', '')
endfunction
augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

augroup LightlineColorscheme
  autocmd!
  autocmd VimResume,VimEnter * call s:lightline_update()
augroup END
function! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  let g:lightline.colorscheme = 'Tomorrow'

  call s:read_background()
  try
    if g:colors_name =~# 'night'
      let g:lightline.colorscheme = 'Tomorrow_Night'
    endif
  catch
    " do nothing
  endtry

  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

" Highlight TODOs etc
"
" TODO: Define regex for todos and notes a the beginning of this
" source and use them to define two commands :Todo and :Note that use
" :grep to search for them. Reuse the regexes below to highlight their
" occurences.
if has('autocmd')
  if v:version > 701
    augroup highlight_todo
      autocmd!
      autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|BAD PRACTICE\)')
      autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
    augroup END
  endif
endif

augroup _ale_closeLoclistWithBuffer
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" NeoVim/Vim compatibility {{{2

if !has('nvim')
  set cryptmethod=blowfish2
  set ttymouse=xterm2

  " Change cursor depending on mode in terminal
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
  else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
  endif
endif

" Project-specifics {{{1

augroup project_specifics
  autocmd! BufRead */some-project/*.html let b:ale_fixers = []
augroup end

" .vimrc.local {{{1

" Allows to override settings above for machine specifics
if filereadable(expand('$HOME/.vimrc.local'))
  execute 'source ' . '$HOME/.vimrc.local'
endif
