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

call plug#begin('$DOTVIM/plugged')

Plug 'editorconfig/editorconfig-vim'

Plug 'easymotion/vim-easymotion'
Plug 'wellle/targets.vim'
Plug 'machakann/vim-highlightedyank'

Plug 'tpope/vim-abolish'  " improved substitution
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'  " sugar for UNIX shell commands
Plug 'tpope/vim-obsession'  " session management
Plug 'tpope/vim-repeat' " support for repeating commands that don't support repetition natively
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'  " auto-indenting
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired' " pairs of handy bracket mappings
Plug 'tpope/vim-vinegar' " better netrw
Plug 'tpope/vim-fugitive' " git integration
Plug 'tpope/vim-rhubarb'  " fugitive GitHub integration
Plug 'tpope/vim-projectionist'

Plug 'lervag/vimtex', { 'tag': 'v2.15' }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vader.vim' " test framework for development

Plug 'w0rp/ale'

Plug 'sheerun/vim-polyglot'

Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'vim-airline/vim-airline'

call plug#end()

let g:airline_theme = 'catppuccin'
colorscheme catppuccin-mocha

runtime! ftplugin/man.vim " :Man for manpages

set autowrite
set backspace=indent,eol,start
set clipboard+=unnamed
set cpoptions+=$
set hidden
set ignorecase
set incsearch
set linebreak
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set modelines=5
set mouse=a
set nobackup
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
  set grepprg=rg\ --hidden\ --vimgrep
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
  else
    set guifont=JetBrainsMono\ Nerd\ Font:h14
  endif
endif


vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" TODO: do I really need this or do I want to set this per project?
let g:projectionist_heuristics = json_decode(join(readfile(expand($DOTVIM . '/misc/projections.json'))))

let g:ale_fix_on_save = 1
let g:ale_list_window_size = 7
let g:ale_javascript_eslint_suppress_missing_config = 1
let g:ale_sign_warning = '?'
let g:ale_sign_error = '!'
let g:ale_sign_info = 'o'

nnoremap ga :edit %<.
noremap <C-s> :w<cr>

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

noremap         ; :
cnoremap <expr> ; getcmdpos() == 1 ? '<Esc>q:' : ';'

nnoremap <leader>gg :Git<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>ga :Git blame<cr>
nnoremap <leader>gB :.Git blame<cr>
nnoremap <leader>gj :Gwrite<bar>G commit<cr>
nnoremap <leader>gp :Git pull<cr>
nnoremap <leader>gP :Git push<cr>

" ALE
nmap <silent> [d <Plug>(ale_previous_wrap)
nmap <silent> ]d <Plug>(ale_next_wrap)

" clever substitute in entire file
nnoremap <expr> <leader>r :%S/<cword>/<cword>/w<left><left>


command! BD :bp\|bd #<cr>
command! BW :bp\|bw #<cr>

command! CD :cd %:p:h<CR>:pwd<CR>

command! YankFullPath :let @+ = expand("%")
command! YankFilename :let @+ = expand("%:t")
command! YankFullPathLineColumn :let @+ = expand("%")   . ':' . line('.') . ':' . col('.')
command! YankFilenameLineColumn :let @+ = expand("%:t") . ':' . line('.') . ':' . col('.')


" Expand %% to the current directory
cabbrev <expr> %% expand('%:p:h')


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


augroup _ale_closeLoclistWithBuffer
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

augroup _ale_enforce_omnifunc
  " Otherwise vim-polyglot will override omnifunc when loading its html
  " features for markdown.
  autocmd FileType * setlocal omnifunc=ale#completion#OmniFunc
augroup END


if !has('nvim')
  set cryptmethod=blowfish2

  " Change cursor depending on mode in terminal
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
  else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
  endif
endif


" Allows to override settings above for machine specifics
if filereadable(expand('$HOME/.vimrc.local'))
  execute 'source ' . '$HOME/.vimrc.local'
endif
