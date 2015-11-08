let mapleader = ","

call pathogen#infect() 

" allows displaying of man pages with :Man <program>
runtime! ftplugin/man.vim

scriptencoding utf-8

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
map <leader>s :setlocal spell!<CR>

" printing
set pdev=PDF
set printoptions=paper:A4,syntax:y,wrap:y,duplex:long
map <leader>hb :setlocal printoptions=paper:A4,syntax:n,wrap:y,duplex:long<CR>:ha<CR>
map <leader>hc :setlocal printoptions=paper:A4,syntax:y,wrap:y,duplex:long<CR>:ha<CR>

" opens file at the line that was edited last
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif

" always cd to the dir of the file we're editing
autocmd BufEnter * silent! lcd %:p:h

autocmd BufNewFile,BufRead *.adoc set filetype=asciidoc

autocmd FileType tex  setlocal number fo+=t tw=80 spell
autocmd FileType text setlocal fo+=ant tw=80 spell
autocmd FileType mail setlocal fo+=n spell formatprg=par\ qer
autocmd FileType asciidoc setlocal number wrap spell
autocmd FileType rmd setlocal spell

"iab YDATE <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
"map ,L  1G/Latest change:\s*/e+1<CR>CYDATE<ESC>

" kill quote spaces when quoting a quote
"map ,kqs mz:%s/^> >/>>/<cr>

" delete trailing white space
"nmap ;tr :%s/\s\+$//
"vmap ;tr :s/\s\+$//

" http://vimcasts.org/episodes/soft-wrapping-text/
vmap <C-j> gj
vmap <C-k> gk
vmap <C-4> g$
vmap <C-6> g^
vmap <C-0> g^
nmap <C-j> gj
nmap <C-k> gk
nmap <C-4> g$
nmap <C-6> g^
nmap <C-0> g^

":imap <S-Space> <Esc>

" simply type w!! to save as root
if has("unix")
    cmap w!! w !sudo tee >/dev/null %
endif

" mintty setup
"let &t_ti.="\e[1 q"
"let &t_SI.="\e[5 q"
"let &t_EI.="\e[1 q"
"let &t_te.="\e[0 q"


" saves the file and silently commits and pushes to git repo
" this needs vim-fugitive
function! Gfast()
    execute ":Gwrite"
    execute ":Gcommit -m 'fast commit'"
    execute ":Gpush"
endfunction
command! Gfast call Gfast()

colorscheme base16-brewer
set background=dark
let base16colorspace=256

if has('gui_running')
    colorscheme base16-brewer
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions+=R
    set lines=32
    set columns=82
    if has("gui_gtk2")
        set guifont=Monospace\ 10
        set background=dark
    endif
    if has("gui_win32")
        set guifont=Liberation_Mono:h11:cANSI
    endif
endif

" this is for the vim-latex plugin (http://vim-latex.sourceforge.net)
" setting grep to always generate a file-name
set grepprg=grep\ -nH\ $*

" if it's a tex-file always set the filetype to be latex
let g:tex_flavor = "latex"

" allow inserting e-acute again
" ref: http://vim-latex.sourceforge.net/index.php?subject=faq#faq-e-acute
imap <buffer> <leader>it <Plug>Tex_InsertItemOnThisLine

"" do not replace quotes automatically
let g:Tex_SmartKeyQuote = 0

"" to use label completion with <C-n>
set iskeyword+=:

" speed up vim-pandoc
"let g:pandoc_no_empty_implicits = 1
"let g:pandoc_no_spans = 1
"let g:pandoc_no_folding = 1

" change modifier for vim-move
"let g:move_key_modifier = 'C'

filetype plugin indent on
syntax on
