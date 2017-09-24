set nocompatible
filetype off

" VUNDLE =================
if has("win32")
    set rtp+=$HOME/vimfiles/bundle/Vundle.vim/
    call vundle#begin('$HOME/vimfiles/bundle/')
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

"Plugin 'LucHermitte/lh-vim-lib'
"Plugin 'LucHermitte/local_vimrc'
"Plugin 'ervandrew/supertab'
"Plugin 'reedes/vim-pencil'
"Plugin 'reedes/vim-thematic'
Plugin 'Raimondi/delimitMate'
Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'chilicuil/vim-sprunge'
Plugin 'chriskempson/base16-vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'embear/vim-localvimrc'
Plugin 'godlygeek/tabular'
Plugin 'gregsexton/gitv'
Plugin 'hashivim/vim-terraform'
Plugin 'jalvesaq/Nvim-R'
Plugin 'jamessan/vim-gnupg'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'lervag/vimtex'
Plugin 'mattn/emmet-vim'
Plugin 'matze/vim-move'
Plugin 'mllg/vim-devtools-plugin'
Plugin 'reedes/vim-lexical'
Plugin 'tommcdo/vim-exchange'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/VOoM'
Plugin 'vimoutliner/vimoutliner'
Plugin 'zhou13/vim-easyescape'

" Syntax
Plugin 'baskerville/vim-sxhkdrc'
Plugin 'blindFS/vim-reveal'
Plugin 'cespare/vim-toml'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'

call vundle#end()

filetype plugin indent on
syntax on

" EXTENSIONS =============

" allows displaying of man pages with :Man <program>
runtime! ftplugin/man.vim

" GENERAL ================

let mapleader = ","

set autowrite
set backspace=indent,eol,start
set cpo+=$
set cryptmethod=blowfish
set hidden
set ignorecase
set incsearch
set linebreak
set modelines=5
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
set viminfo=%,'50,:100,<1000
set visualbell
set whichwrap=<,>,h,l
set wildmenu
set updatetime=250

if(has("win32"))
    set backupdir=~/vimfiles/backup//
    set directory=~/vimfiles/swap//,.
    set undodir=~/vimfiles/undo//
else
    set backupdir=~/.vim/backup//
    set directory=~/.vim/swap//,/var/tmp//,/tmp//,.
    set undodir=~/.vim/undo//
endif

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

set laststatus=2

" encoding
scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8

" formatting
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set comments=b:#,:%,fb:-,n:>,n:)
set formatoptions=croq

autocmd FileType r setlocal tabstop=2 shiftwidth=2 softtabstop=2

set spelllang=de_20,en_gb
set spellfile=~/.vim/spell/de.utf-8.add

" changes cursor depending on mode
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

" cd to the directory of the file current file
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Expand %% to the current directory
cabbr <expr> %% expand('%:p:h')

" printing
"set pdev=PDF

" printing
"set pdev=PDF
"set printoptions=paper:A4,syntax:y,wrap:y,duplex:long
"map <leader>hb :setlocal printoptions=paper:A4,syntax:n,wrap:y,duplex:long<CR>:ha<CR>
"map <leader>hc :setlocal printoptions=paper:A4,syntax:y,wrap:y,duplex:long<CR>:ha<CR>

" MAPS & ABBREVIATIONS ===

nmap <leader>ms :1,7s/<.*@niklaas.eu/<stdin@niklaas.eu<CR><C-o>
nmap <leader>mm :1,7s/<.*@niklaas.eu/<me@niklaas.eu<CR><C-o>
nmap <leader>mp :1,1s/<.*@\(.*\)>/<postmaster@\1><CR><C-o>

"map ,L  1G/Latest change:\s*/e+1<CR>CYDATE<ESC>

" kill quote spaces when quoting a quote
"map ,kqs mz:%s/^> >/>>/<cr>

" delete trailing white space
"nmap ;tr :%s/\s\+$//
"vmap ;tr :s/\s\+$//

" type w!! to save as root
if has("unix")
    cmap w!! w !sudo tee >/dev/null %
endif

" Eases navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 2000
cnoremap jk <ESC>
cnoremap kj <ESC>

" inserts timestamp (ISO compliant with colon in timezone)
ia aDT <C-R>=strftime("%FT%T%z")<CR><ESC>hi:<ESC>lla

" PLUGINS ================

let g:sprunge_map = "<leader><leader>s"
let g:sprunge_open_browser = 1

let g:voom_tree_placement = "top"
let g:voom_tree_height = 5

let g:lexical#spell_key = '<leader>s'
let g:lexical#thesaurus_key = '<leader>t'
let g:lexical#dictionary_key = '<leader>k'

" Goyo
function! s:goyo_enter()
    "silent !tmux set status off
    set noshowmode
    set noshowcmd
    set scrolloff=999
    set spell
    if has('gui_running')
        set linespace=4
    endif
    Limelight
endfunction

function! s:goyo_leave()
    "silent !tmux set status on
    set showmode
    set showcmd
    set scrolloff=5
    if has('gui_running')
        set linespace=0
    endif
    Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Tabularize

nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>

if executable('ag')
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
endif

set t_Co=256
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
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
    if has("gui_gtk2")
        set guifont=Monospace\ 11
        set background=dark
    elseif has("gui_win32")
        set guifont=Consolas:h10:cANSI
    endif
endif

" vimtex
if has("win32")
    let g:vimtex_view_general_viewer = 'SumatraPDF'
    let g:vimtex_view_general_options
        \ = '-reuse-instance -forward-search @tex @line @pdf'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
endif

" Nvim-R
let R_in_buffer = 0
let R_tmux_split = 1
let R_nvim_wd = 1
let R_assign = 0
