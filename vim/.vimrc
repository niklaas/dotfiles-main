set nocompatible

let mapleader = ","

if has("win32")
    let $DOTVIM = expand('$HOME/vimfiles')
    let $MYREALVIMRC = expand('$HOME/_vimrc')
else
    let $DOTVIM = expand('$HOME/.vim')
    let $MYREALVIMRC = expand('$HOME/.vimrc')
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-PlUG

call plug#begin('$DOTVIM/plugged')

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
Plug 'jamessan/vim-gnupg'
Plug 'mattn/emmet-vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mkitt/tabline.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rhysd/clever-f.vim'
Plug 'vim-scripts/SyntaxAttr.vim'

" tpope plugins
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'  " sugar for UNIX shell commands
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'  " for better netrw


Plug 'zhou13/vim-easyescape'
let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 2000

" Includes *multiple* syntax/completion/etc rules
" This should be includes first to be overridden subsequently
Plug 'sheerun/vim-polyglot'

" Fugitive ===========================================================
Plug 'tpope/vim-fugitive'

" Auto-clean fugitive buffers
augroup fugitive_clean
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
  autocmd BufReadPost term://.//*:git* set bufhidden=delete
augroup END

nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gb :Gblame<cr>

Plug 'sodapopcan/vim-twiggy'
nnoremap <leader>b :Twiggy<cr>

Plug 'junegunn/gv.vim'

nnoremap <leader>gV :GV<cr>

" Projectionist ======================================================
Plug 'tpope/vim-projectionist'
let g:projectionist_heuristics = {
   \  "config/prod.exs": {
   \    "web/controllers/*_controller.ex": {
   \      "type": "controller",
   \      "alternate": "test/controllers/{}_controller_test.exs",
   \    },
   \    "web/models/*.ex": {
   \      "type": "model",
   \      "alternate": "test/models/{}_test.exs",
   \    },
   \    "web/views/*_view.ex": {
   \      "type": "view",
   \      "alternate": "test/views/{}_view_test.exs",
   \    },
   \    "web/templates/*.html.eex": {
   \      "type": "template",
   \      "alternate": "web/views/{dirname|basename}_view.ex"
   \    },
   \    "test/*_test.exs": {
   \      "type": "test",
   \      "alternate": "web/{}.ex",
   \    }
   \  }
   \}

nnoremap <localleader>ec :Econtroller<Space>
nnoremap <localleader>em :Emodel<Space>
nnoremap <localleader>et :Etemplate<Space>
nnoremap <localleader>eT :Etest<Space>
nnoremap <localleader>ev :Eview<Space>

nnoremap aa :A<CR>
nnoremap av :AV<CR>
nnoremap as :AS<CR>
nnoremap at :AT<CR>

" Ctrlp ==============================================================
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'a'

if has('unix')
  if executable('fd')
    let g:ctrlp_use_caching  = 0
    let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
  else
    let g:ctrlp_user_command = {
    \ 'types': {
      \ 1: ['.git', 'cd %s && git ls-files -co --exclude-standard']
      \ },
    \ 'fallback': 'find %s -type f'
    \ }
  endif
endif

if filereadable('web/router.ex')
    " This looks like an Elixir/Phoenix app.
    nnoremap pc :CtrlP web/controllers<CR>
    nnoremap pm :CtrlP web/models<CR>
    nnoremap pT :CtrlP test<CR>
    nnoremap pt :CtrlP web/templates<CR>
    nnoremap pv :CtrlP web/views<CR>
endif

" Grepper ============================================================
Plug 'mhinz/vim-grepper'
let g:grepper = {}
let g:grepper.tools = ['git', 'rg', 'grep']
let g:grepper_jump = 1

nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

nnoremap <leader>gg :Grepper -tool git<cr>
nnoremap <leader>gr :Grepper -tool rg<cr>
nnoremap <leader>gv :Grepper -tool rg -side<cr>
nnoremap <leader>*  :Grepper -tool rg -cword -noprompt<cr>

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

augroup filetype_scala
  autocmd!
  autocmd FileType scala nnoremap <localleader>df :EnDeclaration>CR>
  autocmd BufWritePost *.scala silent :EnTypeChec
augroup END

nnoremap <localleader>t :EnType<CR>

let g:scala_scaladoc_indent = 1

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

" JavaScript/Typescript/Angular ======================================
Plug 'leafgarland/typescript-vim'
Plug 'matthewsimo/angular-vim-snippets'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'pangloss/vim-javascript'

" Completion =========================================================

if !exists('g:gui_oni')
    " Completion isn't needed in Oni because it ships with it's own.

    " FIXME: `mhartington/nvim-typescript` Breaks ALE. When the linter find's
    " an error. These errors are no longer showed permantly but only appear in
    " the status line for a very short time.
    Plug 'mhartington/nvim-typescript', Cond(has('nvim'), {'do': 'sh install.sh'})
    let g:nvim_typescript#default_mappings = 1

    " Language Server Protocol (LSP) support
    Plug 'autozimu/LanguageClient-neovim', Cond(has('nvim'), {
                \ 'branch': 'next',
                \ 'do': 'sh install.sh',
                \ })

    set runtimepath+=$DOTVIM/plugged/deoplete.nvim
    let g:deoplete#enable_at_startup = 1
    call deoplete#custom#var('file', 'enable_buffer_path', v:true)

    Plug 'Shougo/deoplete.nvim', Cond(has('nvim'), { 'do': ':UpdateRemotePlugins' })

    Plug 'Shougo/neosnippet.vim'
    Plug 'Shougo/neosnippet-snippets'

    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    smap <C-k> <Plug>(neosnippet_expand_or_jump)
    xmap <C-k> <Plug>(neosnippet_expand_or_target)

    " Required for deoplete for normal vim
    Plug 'roxma/nvim-yarp', Cond(!has('nvim'))
    Plug 'roxma/vim-hug-neovim-rpc', Cond(!has('nvim'))
endif

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
Plug 'othree/html5.vim'
Plug 'othree/html5-syntax.vim'

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

  let g:ale_fixers = {
        \ 'typescript': ['tslint']
        \ }

  let g:ale_fix_on_save = 1
  let g:ale_completion_enabled = 0

  map gd <Plug>(ale_go_to_definition)
  map gD <Plug>(ale_go_to_definition_in_tab)
endif

" Sprunge ============================================================
Plug 'chilicuil/vim-sprunge'
let g:sprunge_map = "<leader>p"
let g:sprunge_open_browser = 1

call plug#end()

" EXTENSIONS =============

" allows displaying of man pages with :Man <program>
runtime! ftplugin/man.vim

" Basic settings --------------------------------------------------{{{

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
set nostartofline
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
set wildmode=longest,full

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
set showtabline=2

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
set shiftround
set expandtab autoindent
set tabstop=2 shiftwidth=2 softtabstop=2

" Spelling
set spelllang=en_us,de_20
set spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/de.utf-8.add

" }}}

" Filetype-specific settings --------------------------------------{{{

augroup filetype_gitcommit
  autocmd!
  autocmd FileType gitcommit setlocal comments+=fb:- fo+=c spell
augroup END

augroup filetype_html
  autocmd!
  autocmd FileType html setlocal foldmethod=syntax
augroup END

augroup filetype_typescript
  autocmd!
  autocmd FileType typescript nnoremap <buffer> ,ti :TSImport<cr>
augroup END

augroup filetype_vimrc
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}

" Miscellaneous settings ------------------------------------------{{{

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

" }}}

" Mappings --------------------------------------------------------{{{

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <Leader>cc :set cursorline! cursorcolumn!<CR>
nnoremap Y y$
nnoremap <space> viw
nnoremap <leader>ve :vsplit $MYREALVIMRC<cr>
nnoremap <leader>vs :source $MYREALVIMRC<cr>

cnoremap jk <ESC>
cnoremap kj <ESC>
cnoremap w!! w !sudo tee >/dev/null %

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

" }}}

" Abbreviations ---------------------------------------------------{{{

" Inserts timestamp (ISO compliant with colon in timezone)
iabbrev aDT <C-R>=strftime("%FT%T%z")<CR><ESC>hi:<ESC>lla

" Expand %% to the current directory
cabbrev <expr> %% expand('%:p:h')

" }}}

" Display & style -------------------------------------------------{{{

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

" }}}

" GUI settings ----------------------------------------------------{{{

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

" }}}

" NeoVim/Vim compatibility ----------------------------------------{{{

if !has('nvim')
  set cryptmethod=blowfish2
  set ttymouse=xterm2
endif

" }}}

" ONI -------------------------------------------------------------{{{

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

" }}}
