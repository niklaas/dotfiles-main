set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-PlUG

if has("win32")
  call plug#begin('$HOME/vimfiles/plugged')
else
  call plug#begin('$HOME/.vim/plugged')
endif

" Conditional activation for vim-plug plugins
" https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'embear/vim-localvimrc'
Plug 'gregsexton/gitv'
Plug 'idanarye/vim-merginal'  " for git branching
Plug 'jamessan/vim-gnupg'
Plug 'mattn/emmet-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'zhou13/vim-easyescape'

" Fugitive ===========================================================
Plug 'tpope/vim-fugitive'

" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost term://.//*:git* set bufhidden=delete

Plug 'sodapopcan/vim-twiggy'

" Ctrlp ==============================================================
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

if has("unix")
  let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files']
    \ },
  \ 'fallback': 'find %s -type f'
  \ }
endif

" DelimitMate ========================================================
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr = 1

" Easy Align =========================================================
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Scala ==============================================================
Plug 'derekwyatt/vim-sbt'
Plug 'derekwyatt/vim-scala'
autocmd FileType scala nnoremap <localleader>df :EnDeclaration>CR>
autocmd BufWritePost *.scala silent :EnTypeChec
nnoremap <localleader>t :EnType<CR>
let g:scala_scaladoc_indent = 1

" VOom ===============================================================
Plug 'vim-scripts/VOoM'
let g:voom_tree_placement = "top"
let g:voom_tree_height = 5

" Airtline ===========================================================
Plug 'vim-airline/vim-airline', Cond(!exists('g:gui_oni'))
Plug 'vim-airline/vim-airline-themes', Cond(!exists('g:gui_oni'))
let g:airline_theme = 'base16_default'

" Pandoc =============================================================
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-rmarkdown'
let g:pandoc#modules#disabled = ["chdir"]
"let g:pandoc#formatting#mode = "hA"

" Vimtex =============================================================
Plug 'lervag/vimtex'
if has("win32")
  let g:vimtex_view_general_viewer = 'SumatraPDF'
  let g:vimtex_view_general_options
    \ = '-reuse-instance -forward-search @tex @line @pdf'
  let g:vimtex_view_general_options_latexmk = '-reuse-instance'
endif

" NVim-R =============================================================
Plug 'jalvesaq/Nvim-R'
let R_in_buffer = 0
let R_tmux_split = 1
let R_nvim_wd = 1
let R_assign = 0
let r_indent_ess_compatible = 1

" Completion =========================================================

" TODO: Configure completion for normal vim. Use case: Use functionality on a
" remote machine.Problem: All of these gimmicks require python3 and I'm note
" sure whether I want to install what comes with all of this.
if has('nvim') && !exists('g:gui_oni')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
endif

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Syntax rules =======================================================

Plug 'baskerville/vim-sxhkdrc'
Plug 'blindFS/vim-reveal'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'mllg/vim-devtools-plugin'
Plug 'mrk21/yaml-vim'
Plug 'slashmili/alchemist.vim'
Plug 'elixir-editors/vim-elixir'

" Syntastic or ALE?
if v:version < 800
  Plug 'vim-syntastic/syntastic'

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 0
  let g:syntastic_check_on_wq = 0

  let g:syntastic_ignore_files = ['\m\c.h$', '\m\.sbt$']
  " Only use one of `scalac` or `fsc` for checking syntax in Scala
  let g:syntastic_scala_checkers = ['fsc']

  let g:syntastic_enable_r_lintr_checker = 1
  let g:syntastic_r_checkers = ['lintr']
else
  Plug 'w0rp/ale'
endif

Plug 'vimoutliner/vimoutliner'


" Prose writing ======================================================
"Plug 'junegunn/limelight.vim'
"Plug 'reedes/vim-pencil'
"Plug 'reedes/vim-thematic'
"Plug 'tommcdo/vim-exchange'

"Plug 'reedes/vim-lexical'
"let g:lexical#spell_key = '<leader>s'
"let g:lexical#thesaurus_key = '<leader>t'
"let g:lexical#dictionary_key = '<leader>k'

" Sprunge ============================================================
Plug 'chilicuil/vim-sprunge'
let g:sprunge_map = "<leader><leader>s"
let g:sprunge_open_browser = 1

call plug#end()

" EXTENSIONS =============

" allows displaying of man pages with :Man <program>
runtime! ftplugin/man.vim

" GENERAL ================

let mapleader = ","

set autowrite
set backspace=indent,eol,start
set cpo+=$
set hidden
set ignorecase
set incsearch
set linebreak
set list
set modelines=5
set mouse=a
set nobackup
set nojoinspaces
set nowrap
set pastetoggle=<f11>
set ruler
set shortmess=at
set showbreak=+
set showmatch
set smartcase
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tags=./tags,./TAGS,tags,TAGS,../tags,../../tags,../../../tags,../../../../tags
set updatetime=250
set viminfo=%,'50,:100,<1000
set visualbell
set whichwrap=<,>,h,l
set wildmenu

" Set locations of important directories depending on OS
if(has("win32"))
  set backupdir=~/vimfiles/backup//
  set directory=~/vimfiles/swap//,.
  set undodir=~/vimfiles/undo//
else
  set backupdir=~/.vim/backup//
  set directory=~/.vim/swap//,/var/tmp//,/tmp//,.
  set undodir=~/.vim/undo//
endif

" Always show status line
set laststatus=2

" Encoding and file format
scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix
set fileformats=unix,dos

" formatting
set comments=b:#,:%,fb:-,n:>,n:)
set formatoptions=croq

if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=18
endif

" Indenting
set expandtab autoindent
set tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType r         setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType rmd       setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType vim       setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType yaml      setlocal tabstop=2 shiftwidth=2 softtabstop=2

autocmd FileType gitcommit setlocal comments+=fb:- fo+=c

" Spelling
set spelllang=en_us,de_20
set spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/de.utf-8.add

autocmd FileType gitcommit setlocal spell

" Fix highlighting for spell checks in terminal
function! s:base16_customize() abort
  " Colors: https://github.com/chriskempson/base16/blob/master/styling.md
  " Arguments: group, guifg, guibg, ctermfg, ctermbg, attr, guisp
  call Base16hi("SpellBad",   "", "", g:base16_cterm08, g:base16_cterm00, "", "")
  call Base16hi("SpellCap",   "", "", g:base16_cterm0A, g:base16_cterm00, "", "")
  call Base16hi("SpellLocal", "", "", g:base16_cterm0D, g:base16_cterm00, "", "")
  call Base16hi("SpellRare",  "", "", g:base16_cterm0B, g:base16_cterm00, "", "")
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

" Change cursor depending on mode in terminal
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

" cd to the directory of the file current file
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Expand %% to the current directory
cabbr <expr> %% expand('%:p:h')

" MAPS & ABBREVIATIONS ===

nnoremap <Leader>cc :set cursorline! cursorcolumn!<CR>

" Replace sender in emails
nmap <leader>ms :1,7s/<.*@niklaas.eu/<stdin@niklaas.eu<CR><C-o>
nmap <leader>mm :1,7s/<.*@niklaas.eu/<me@niklaas.eu<CR><C-o>
nmap <leader>mp :1,1s/<.*@\(.*\)>/<postmaster@\1><CR><C-o>

" type w!! to save as root
if has("unix")
  cmap w!! w !sudo tee >/dev/null %
endif

" Eases navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

if has('nvim')
  tnoremap <C-H> <c-\><c-n><c-w>h
  tnoremap <C-J> <c-\><c-n><c-w>j
  tnoremap <C-K> <c-\><c-n><c-w>k
  tnoremap <C-L> <c-\><c-n><c-w>l

  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-[> <Esc>
  tnoremap <C-v><Esc> <Esc>
endif

nnoremap Y y$

" Escape with jk
let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 2000
cnoremap jk <ESC>
cnoremap kj <ESC>

" Inserts timestamp (ISO compliant with colon in timezone)
ia aDT <C-R>=strftime("%FT%T%z")<CR><ESC>hi:<ESC>lla

if executable('ag')
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
endif

" Colors
set t_Co=256
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Reference: https://jeffkreeftmeijer.com/vim-number/
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI

if has('gui_running')
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
  set lines=50
  set columns=120
  if has("gui_gtk2")
    set guifont=Monospace\ 11
    set background=dark
  elseif has("gui_win32")
    set guifont=Consolas:h10:cANSI
  endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NeoVim

if !has('nvim')
  set cryptmethod=blowfish2
  set ttymouse=xterm2
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ONI

if exists('g:gui_oni')
  " Override previous configuration with these setting to suit to Oni.
  " https://github.com/onivim/oni/wiki/How-To:-Minimal-Oni-Configuration

  " Force loading sensible now to override its setting in the following
  " lines
  runtime plugin/sensible.vim

  set number
  set noswapfile
  set smartcase

  set noshowmode
  set noruler
  set laststatus=0
  set noshowcmd

  set mouse=a
endif
