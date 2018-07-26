set nocompatible

let mapleader = ","

if has("win32")
    let $DOTVIM = expand('$HOME/vimfiles')
    let $MYREALVIMRC = expand('$HOME/_vimrc')
else
    let $DOTVIM = expand('$HOME/.vim')
    let $MYREALVIMRC = expand('$HOME/.vimrc')
endif

" Vim-plug --------------------------------------------------------{{{

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
Plug 'jamessan/vim-gnupg'
Plug 'mattn/emmet-vim'
Plug 'vim-scripts/SyntaxAttr.vim'

" Objects ---------------------------------------------------------{{{

Plug 'michaeljsmith/vim-indent-object'
Plug 'rhysd/clever-f.vim'
Plug 'wellle/targets.vim'

" }}}

Plug 'vim-scripts/dbext.vim'

Plug 'majutsushi/tagbar' "{{{
nnoremap <leader>tt :TagbarToggle<cr>
nnoremap <leader>to :TagbarOpen fj<cr>
nnoremap <leader>tO :TagbarOpenAutoClose<cr>
nnoremap <leader>tc :TagbarClose<cr>
nnoremap <leader>tp :TagbarPause<cr>
"}}}

" DelimitMate ========================================================
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" tpope plugins ---------------------------------------------------{{{
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'  " sugar for UNIX shell commands
Plug 'tpope/vim-obsession'  " for session management
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'  " for better netrw

nnoremap <leader>dD :Dispatch!<cr>
nnoremap <leader>dd :Dispatch<cr>
nnoremap <leader>dm :Make!<cr>
nnoremap <leader>dm :Make<cr>

nnoremap <leader>o :Obsession<cr>
nnoremap <leader>O :Obsession!<cr>

Plug 'tpope/vim-fugitive' "{{{

" Auto-clean fugitive buffers
augroup fugitive_clean
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
  autocmd BufReadPost term://.//*:git* set bufhidden=delete
augroup END

nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
"}}}

Plug 'tpope/vim-projectionist' "{{{
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

nnoremap <leader>aa :A<CR>
nnoremap <leader>av :AV<CR>
nnoremap <leader>as :AS<CR>
nnoremap <leader>at :AT<CR>
"}}}
"}}}

" Includes *multiple* syntax/completion/etc rules
" This should be includes first to be overridden subsequently
Plug 'sheerun/vim-polyglot'

Plug 'sodapopcan/vim-twiggy' "{{{
nnoremap <leader>b :Twiggy<cr>
"}}}

Plug 'junegunn/gv.vim' "{{{
nnoremap <leader>gv :GV<cr>
"}}}

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

nnoremap <leader>Gg :Grepper -tool git<cr>
nnoremap <leader>Gr :Grepper -tool rg<cr>
nnoremap <leader>Gv :Grepper -tool rg -side<cr>
nnoremap <leader>*  :Grepper -tool rg -cword -noprompt<cr>

" Easy Align =========================================================
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Plugins for syntax {{{

" Scala ==============================================================
Plug 'derekwyatt/vim-sbt'
Plug 'derekwyatt/vim-scala'

augroup filetype_scala
  autocmd!
  autocmd BufWritePost *.scala silent :EnTypeChec
augroup END

let g:scala_scaladoc_indent = 1

Plug 'vim-airline/vim-airline', Cond(!exists('g:gui_oni')) " {{{
Plug 'vim-airline/vim-airline-themes', Cond(!exists('g:gui_oni'))
let g:airline_theme = 'base16_default'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#bufferline#enabled = 1
set noshowmode " because airline shows it
"}}}

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
Plug 'burnettk/vim-angular'
Plug 'heavenshell/vim-jsdoc'
Plug 'leafgarland/typescript-vim', Cond(!has('nvim'))
Plug 'matthewsimo/angular-vim-snippets'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'pangloss/vim-javascript'

" Java/Eclipse/eclim ================================================
Plug 'dansomething/vim-eclim', { 'for': 'java' }
let g:EclimJavaSearchSingleResult = 'edit'
"}}}

" LSP / completion / related --------------------------------------{{{
if !exists('g:gui_oni')
  " Prerequisites for completion
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'

  " Registering LSPs
  if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
          \ 'whitelist': ['typescript'],
          \ })
  endif

  " Configuration for completion and LSPs
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
  let g:asyncomplete_remove_duplicates = 1
  let g:lsp_signs_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1

  " For debugging LSPs
  "let g:lsp_log_verbose = 1
  "let g:lsp_log_file = expand('~/vim-lsp.log')
  "let g:asyncomplete_log_file = expand('~/asyncomplete.log')  " for asyncomplete.vim log

  " Mappings for completion and LSPs
  nnoremap <leader>lh :LspHover<cr>
  nnoremap <leader>ld :LspDefinition<cr>
  nnoremap <leader>lr :LspReferences<cr>
  nnoremap <leader>lR :LspRename<cr>
  nnoremap <leader>lf :LspDocumentRangeFormat<cr>
  nnoremap <leader>lF :LspDocumentFormat<cr>
  nnoremap <leader>ll :LspDocumentDiagnostics<cr>
endif
"}}}

" Syntax rules =======================================================

Plug 'baskerville/vim-sxhkdrc'
Plug 'blindFS/vim-reveal'  " reveal.js presentations
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'mllg/vim-devtools-plugin'
Plug 'mrk21/yaml-vim'
Plug 'slashmili/alchemist.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'othree/html5.vim'
Plug 'othree/html5-syntax.vim'

" Sprunge ============================================================
Plug 'chilicuil/vim-sprunge'
let g:sprunge_map = "<leader>S"
let g:sprunge_open_browser = 1

call plug#end()

" }}}

" Vim extensions --------------------------------------------------{{{

" allows displaying of man pages with :Man <program>
runtime! ftplugin/man.vim

" }}}

" Basic settings --------------------------------------------------{{{

set autowrite
set backspace=indent,eol,start
set cpo+=$
set hidden
set ignorecase
set incsearch
set linebreak
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
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
set comments=b:#,:%,fb:-,n:>,n:),sr:/**,mb:*,ex:*/,://,:\\"
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

augroup filetype_go
  autocmd!
  autocmd FileType go nnoremap <buffer> <leader>gr :GoRun<cr>
  autocmd FileType go nnoremap <buffer> <leader>gt :GoTest<cr>
  autocmd FileType go nnoremap <buffer> <leader>gb :GoBuild<cr>
augroup END

augroup filetype_html
  autocmd!
  autocmd FileType html setlocal foldmethod=indent
augroup END

augroup filetpye_java
  autocmd!
  autocmd FileType java nnoremap <buffer> <leader>jd :JavaDocComment<cr>
  autocmd FileType java nnoremap <buffer> <leader>ji :JavaImportOrganize<cr>
  autocmd FileType java nnoremap <buffer> <leader>r :JavaSearch -x references<cr>
  autocmd FileType java nnoremap <buffer> K :JavaDocPreview<cr>
  autocmd FileType java nnoremap <buffer> gd :JavaSearch -x declarations<cr>
augroup END

augroup filetype_netrw
  autocmd!
  autocmd FileType netrw setlocal bufhidden=false
augroup END

augroup filetype_typescript
  autocmd!
  autocmd FileType typescript let b:dispatch = 'ng test %'
augroup END

augroup filetype_vimrc
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd Filetype vim setlocal comments+=b:\"
augroup END

" }}}

" Miscellaneous settings ------------------------------------------{{{

" Highlight TODOs etc
if has('autocmd')
  if v:version > 701
    augroup highlight_todo
      autocmd!
      autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
      autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
    augroup END
  endif
endif

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

cnoremap jk <ESC>
cnoremap kj <ESC>
inoremap jk <ESC>
inoremap kj <ESC>

cnoremap w!! w !sudo tee >/dev/null %

" Insert mode {{{

" Jump to end of line
inoremap <C-e> <C-o>$

" Jump to beginning of line (overrides!)
inoremap <C-a> <C-o>_

" }}}

nnoremap <space> viw
nnoremap Y y$
nnoremap / /\v

" Delete the buffer, leaving the window open
nnoremap <C-c> :bp\|bd #<cr>

nnoremap <Leader>, :set cursorline! cursorcolumn!<CR>
nnoremap <Leader>- :set list!<cr>
nnoremap <leader>. :nohlsearch<cr>
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>cp :let @+ = expand("%")<cr>
nnoremap <leader>ve :vsplit $MYREALVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" Yanks current inner paragraph and pastes below
nnoremap <leader>p yip}o<esc>P

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

" Source .vimrc.local ---------------------------------------------{{{

if filereadable(expand('$HOME/.vimrc.local'))
  execute 'source ' . '$HOME/.vimrc.local'
endif

" }}}
