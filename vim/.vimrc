nnoremap <space> <nop>
let mapleader = ' '

if has('win32')
    let $DOTVIM = expand('$HOME/vimfiles')
    let $MYREALVIMRC = expand('$HOME/_vimrc')
else
    let $DOTVIM = expand('$HOME/.vim')
    let $MYREALVIMRC = expand('$HOME/.vimrc')
endif

let g:polyglot_disabled = ['sensible']

call plug#begin('$DOTVIM/plugged')

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

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vader.vim' " test framework for development

Plug 'editorconfig/editorconfig-vim'

Plug 'easymotion/vim-easymotion'
Plug 'wellle/targets.vim'
Plug 'machakann/vim-highlightedyank'

Plug 'lervag/vimtex', { 'tag': 'v2.15' }

Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'

Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'vim-airline/vim-airline'

call plug#end()

let g:airline_theme = 'catppuccin'
colorscheme catppuccin-mocha

setglobal autowrite
setglobal backspace=indent,eol,start
setglobal clipboard+=unnamed
setglobal cpoptions+=$
setglobal hidden
setglobal ignorecase
setglobal linebreak
setglobal listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
setglobal modelines=5
setglobal mouse=a
setglobal nobackup
setglobal nojoinspaces
setglobal noshowmode
setglobal nowrap
setglobal nowritebackup
setglobal number
setglobal pumheight=10
setglobal relativenumber
setglobal shortmess=catOT
setglobal showbreak=+
setglobal showmatch
setglobal signcolumn=yes
setglobal smartcase
setglobal suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
setglobal termguicolors
setglobal undofile
setglobal updatetime=300
setglobal visualbell
setglobal whichwrap=b,s
setglobal wildignorecase

setglobal backupdir=$DOTVIM/backup/
setglobal directory=$DOTVIM/swap/,.
setglobal undodir=$DOTVIM/undo

" Encoding and file format
setglobal encoding=utf-8
scriptencoding utf-8
setglobal fileencoding=utf-8
setglobal fileformat=unix
setglobal fileformats=unix,dos

" Indenting
setglobal shiftround
setglobal expandtab autoindent smartindent
setglobal tabstop=2 shiftwidth=2 softtabstop=2

" Spelling
setglobal spelllang=en_us,de_20
setglobal spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/de.utf-8.add

" Grepping
if executable('rg')
  setglobal grepprg=rg\ --hidden\ --vimgrep
endif

if has('gui_running')
  setglobal guioptions-=m
  setglobal guioptions-=T
  setglobal guioptions-=r
  setglobal guioptions-=R
  setglobal guioptions-=l
  setglobal guioptions-=L
  setglobal lines=50
  setglobal columns=120
  if has('gui_gtk2')
    setglobal guifont=Monospace\ 11
    setglobal background=dark
  elseif has('gui_win32')
    setglobal guifont=Consolas:h10:cANSI
  else
    setglobal guifont=JetBrainsMono\ Nerd\ Font:h14
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

nmap <silent> [d <Plug>(ale_previous_wrap)
nmap <silent> ]d <Plug>(ale_next_wrap)

nnoremap <leader>r :%S/<C-r><C-w>/<C-r><C-w>/w<left><left>

command! BD :bp\|bd #<cr>
command! BW :bp\|bw #<cr>

command! Cd :cd %:p:h<CR>:pwd<CR>

command! YFullPath   :let @+ = expand("%")
command! YFilename   :let @+ = expand("%:t")
command! YFullPathLC :let @+ = expand("%")   . ':' . line('.') . ':' . col('.')
command! YFilenameLC :let @+ = expand("%:t") . ':' . line('.') . ':' . col('.')

cabbrev <expr> %% expand('%:p:h')

exe 'augroup my'
autocmd!

autocmd BufEnter MERGEREQ_EDITMSG setlocal filetype=gitcommit
autocmd BufRead,BufNewFile *.njk  setlocal ft=jinja
autocmd QuitPre *                 if empty(&buftype) | lclose | endif

autocmd FileType gitcommit        setlocal comments+=fb:- fo+=nrbl spell
autocmd FileType html             setlocal foldmethod=indent | normal zR
autocmd FileType netrw            setlocal bufhidden=delete
autocmd FileType markdown         setlocal comments=b:>,fb:-,fb:*,fb:-\ [\ ],fb:-> textwidth=80 fo+=c
autocmd FileType sql              let &l:formatprg = 'python -m sqlparse -k upper -r --indent_width 2 -'
autocmd FileType typescript       let b:ale_javascript_prettier_options = '--parser typescript'
autocmd FileType vim              setlocal foldmethod=marker

" Otherwise vim-polyglot will override omnifunc when loading its html features for markdown.
autocmd FileType *                setlocal omnifunc=ale#completion#OmniFunc

" https://github.com/plasticboy/vim-markdown/issues/126#issuecomment-485579068
autocmd FileType markdown         setlocal indentexpr=

exe 'augroup END'

if !has('nvim')
  set cryptmethod=blowfish2

  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
  else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
  endif
endif

if filereadable(expand('$HOME/.vimrc.local'))
  source '$HOME/.vimrc.local'
endif
