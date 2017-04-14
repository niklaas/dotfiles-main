let g:pathogen_disabled = []

" disable some plugins
call add(g:pathogen_disabled, 'vim-pandoc')
call add(g:pathogen_disabled, 'supertab')

execute pathogen#infect() 
filetype plugin indent on
syntax on

" allows displaying of man pages with :Man <program>
runtime! ftplugin/man.vim

scriptencoding utf-8

let mapleader = ","

set nocompatible
set cpo+=$
set showmatch
set ruler
set nojoinspaces
set modelines=5
set cryptmethod=blowfish
set nobackup
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set autowrite
set hidden
set wildmenu
set pastetoggle=<f11>
set visualbell
set backspace=indent,eol,start
set shortmess=at
set whichwrap=<,>,h,l
set viminfo=%,'50,\"100,:100,n~/.viminfo,<10,f
set tags=./tags,./TAGS,tags,TAGS,../tags,../../tags,../../../tags,../../../../tags
set linebreak
set ignorecase
set smartcase
set incsearch
set nowrap
set showbreak=+
set dir=~/.vimswap//,/var/tmp//,/tmp//,.

"set statusline=%{fugitive#statusline()}

set laststatus=2

set encoding=utf-8
set fileencoding=utf-8

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set comments=b:#,:%,fb:-,n:>,n:)
set formatoptions=croq

set spelllang=de_20,en_gb
set spellfile=~/.vim/spell/de.utf-8.add

let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

" keymaps

nmap <leader>ms :1,7s/<.*@niklaas.eu/<stdin@niklaas.eu<CR><C-o>
nmap <leader>mm :1,7s/<.*@niklaas.eu/<me@niklaas.eu<CR><C-o>
nmap <leader>mp :1,7s/<.*@\(.*\)>/<postmaster@\1><CR><C-o>

" printing
"set pdev=PDF
"set printoptions=paper:A4,syntax:y,wrap:y,duplex:long
"map <leader>hb :setlocal printoptions=paper:A4,syntax:n,wrap:y,duplex:long<CR>:ha<CR>
"map <leader>hc :setlocal printoptions=paper:A4,syntax:y,wrap:y,duplex:long<CR>:ha<CR>

" opens file at the line that was edited last
"autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif

" always cd to the dir of the file we're editing
autocmd BufEnter * silent! lcd %:p:h

let g:sprunge_map = "<leader><leader>s"
let g:sprunge_open_browser = 1

let g:voom_tree_placement = "top"
let g:voom_tree_height = 5

let g:lexical#spell_key = '<leader>s'
let g:lexical#thesaurus_key = '<leader>t'
let g:lexical#dictionary_key = '<leader>k'

" pencil
augroup pencil
    autocmd!
    autocmd FileType text     call pencil#init()
                \ | setl spell
    autocmd FileType mail     call pencil#init()
                \ | setl spell
    autocmd FileType markdown call pencil#init()
                \ | setl spell
augroup END

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

"iab YDATE <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
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

if exists(":Tabularize")
    nmap <leader>a= :Tabularize /=<CR>
    vmap <leader>a= :Tabularize /=<CR>
    nmap <leader>a: :Tabularize /:\zs<CR>
    vmap <leader>a: :Tabularize /:\zs<CR>
endif

" mintty setup
"let &t_ti.="\e[1 q"
"let &t_SI.="\e[5 q"
"let &t_EI.="\e[1 q"
"let &t_te.="\e[0 q"

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
    set lines=32
    set columns=82
    if has("gui_gtk2")
        set guifont=Monospace\ 11
        set background=dark
    endif
    if has("gui_win32")
        set guifont=Liberation_Mono:h11:cANSI
    endif
endif

let g:tex_favour = 'latex'

let R_in_buffer = 0
let R_term = 'xterm'
