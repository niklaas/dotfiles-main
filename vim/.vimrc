" Introduction {{{1
"
" TODO: Provide some general introduction into the structure of the file here.
"
" Linting:
"
" There are several options for linting such as vim-syntastic/syntastic,
" neomake/neomake and others. I decided for a combination of w0rp/ale and
" tpope/vim-dispatch.
"
" I assume that I code on machines that at least have vim with version > 8, so
" in such cases using w0rp/ale is not an issue. That said, I strip it to it's
" very basic functionality i.e., linting. (It supports other options such as
" code completion etc. but I don't use them. There are other plugins that
" focus on this job.)
"
" FIXME: I am not sure whether I need w0rp/ale in oni/omi. Most probably not
" its linting capabilities but maybe the fixers..? IIRC oni/oni only uses LSPs
" (except for TypeScript) so probably some fixing capabilities (such as
" prettier) are required too.

" Environment {{{1

" vint:next-line -ProhibitSetNoCompatible
set nocompatible

let mapleader = ','

if has('win32')
    let $DOTVIM = expand('$HOME/vimfiles')
    let $MYREALVIMRC = expand('$HOME/_vimrc')
else
    let $DOTVIM = expand('$HOME/.vim')
    let $MYREALVIMRC = expand('$HOME/.vimrc')
endif

" Plugins {{{1

call plug#begin('$DOTVIM/plugged')

" Prefix {{{2

" Conditional activation for vim-plug plugins
" https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Basics {{{2

Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jamessan/vim-gnupg'
Plug 'git-time-metric/gtm-vim-plugin'
Plug 'mattn/emmet-vim'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'editorconfig/editorconfig-vim'

Plug 'vim-scripts/dbext.vim'
Plug 'Raimondi/delimitMate'
Plug 'chilicuil/vim-sprunge'

" Navigation
Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'
Plug 'justinmk/vim-sneak'

" Lightline
Plug 'itchyny/lightline.vim', Cond(!exists('g:gui_oni'))
Plug 'daviesjamie/vim-base16-lightline', Cond(!exists('g:gui_oni'))
Plug 'maximbaz/lightline-ale'

" Tmuxline
Plug 'edkolev/tmuxline.vim'

" Vim objects
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

" tpope plugins
Plug 'tpope/vim-abolish'  " for better substitution
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'  " sugar for UNIX shell commands
Plug 'tpope/vim-obsession'  " for session management
Plug 'tpope/vim-ragtag'  " for HTML editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'  " for auto-indenting
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'  " for better netrw
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'

" fugitive integrations
Plug 'shumphrey/fugitive-gitlab.vim'

" Git branches
Plug 'sodapopcan/vim-twiggy'
Plug 'junegunn/gv.vim'

" Fuzzy finding
Plug 'junegunn/fzf', Cond(has('unix'), { 'dir': '~/.fzf', 'do': './install --all' })
Plug 'junegunn/fzf.vim', Cond(has('unix'))

Plug 'mhinz/vim-grepper'
Plug 'junegunn/vim-easy-align'

" LSP / completion / snippets
Plug 'prabirshrestha/asyncomplete.vim', Cond(!exists('g:gui_oni') && v:version >= 800)
Plug 'prabirshrestha/async.vim', Cond(!exists('g:gui_oni') && v:version >= 800)

Plug 'prabirshrestha/asyncomplete-buffer.vim', Cond(!exists('g:gui_oni') && v:version >= 800)
Plug 'prabirshrestha/asyncomplete-file.vim', Cond(!exists('g:gui_oni') && v:version >= 800)

" Snippets
Plug 'SirVer/ultisnips', Cond(!exists('g:gui_oni') && v:version >= 800 && has('python3'))
Plug 'honza/vim-snippets', Cond(!exists('g:gui_oni') && v:version >= 800 && has('python3'))
Plug 'prabirshrestha/asyncomplete-ultisnips.vim', Cond(!exists('g:gui_oni') && v:version >= 800 && has('python3'))

Plug 'prabirshrestha/vim-lsp', Cond(!exists('g:gui_oni') && v:version >= 800)
Plug 'prabirshrestha/asyncomplete-lsp.vim', Cond(!exists('g:gui_oni') && v:version >= 800)

Plug 'w0rp/ale', Cond(v:version >= 800)

" Syntax rules and filetype specific plugins {{{2

" CSV
Plug 'chrisbra/csv.vim'

Plug 'ekalinin/Dockerfile.vim'

" Polyglot
Plug 'sheerun/vim-polyglot'

" LaTeX
Plug 'lervag/vimtex'

" R
Plug 'jalvesaq/Nvim-R'
Plug 'mllg/vim-devtools-plugin'

" JavaScript/Typescript/Angular
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'heavenshell/vim-jsdoc'

" Scala
Plug 'derekwyatt/vim-sbt'
Plug 'derekwyatt/vim-scala'

" Elixir
Plug 'slashmili/alchemist.vim'
Plug 'elixir-editors/vim-elixir'

" Reveal.js presentations
Plug 'blindFS/vim-reveal'

" My own plugins {{{2

" Test framework for development
Plug 'junegunn/vader.vim'

" In the following lines I always load the local version of a plugin if it's
" available. This makes developing much easier. On machines where there is no
" local version, I get the plugin from its GitHub repository.

" lightline-gitdiff
Plug 'niklaas/lightline-gitdiff', Cond(!isdirectory(expand('$HOME/Files/git/lightline-gitdiff')))
Plug '$HOME/Files/git/lightline-gitdiff', Cond(isdirectory(expand('$HOME/Files/git/lightline-gitdiff')), { 'as': 'lightline-gitdiff-local' })

call plug#end()

" Vim extensions {{{2

" allows displaying of man pages with :Man <program>
runtime! ftplugin/man.vim

" Plugin Configuration {{{1

" Lightline
let g:lightline = {
      \ 'colorscheme': 'base16',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'filename', 'gitversion', 'readonly', 'modified' ],
      \             [ 'gitdiff' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'obsession' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename', 'gitversion' ] ],
      \ },
      \ 'component_function': {
      \   'obsession': 'LightlineObsession',
      \   'gitversion': 'GitVersion',
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
      \   'gitdiff': 'middle',
      \ },
      \ }

let g:lightline#ale#indicator_checking = '...'

" Inspired by https://github.com/aoswalt/dotfiles/commit/5c94f1e080e1269d83cfe25b95a86c78c9b8eabb
function! GitVersion()
  let fullname = expand('%')
  let gitversion = ''
  if     fullname =~? 'fugitive://.*/\.git//\(0\|[\d\w]\{2,}\)/.*'
    let gitversion = 'git index'
  elseif fullname =~? 'fugitive://.*/\.git//2/.*'
    let gitversion = 'git target'
  elseif fullname =~? 'fugitive://.*/\.git//3/.*'
    let gitversion = 'git merge'
  elseif &diff == 1
    let gitversion = 'working copy'
  endif
  return gitversion
endfunction

function! LightlineObsession()
  let l:status = strpart(ObsessionStatus(), 1, 1)
  return l:status ==# '$' ? '$' : ''
endfunction

" Tmuxline
let g:tmuxline_powerline_separators = 0

" Tagbar
let g:tagbar_type_typescript = {                                                  
      \ 'ctagstype' : 'typescript',                                                           
      \ 'kinds': [                                                                     
      \   'c:classes',                                                               
      \   'C:modules',                                                            
      \   'n:modules',                                                           
      \   'f:functions',                                                              
      \   'v:variables',                                                              
      \   'V:varlambdas',                                                           
      \   'm:members',                                                               
      \   'i:interfaces',                                                              
      \   't:types',                                                            
      \   'e:enums',                                                            
      \   'I:imports',                                                              
      \ ]
      \ }  

let g:tagbar_type_rust = {
      \ 'ctagstype' : 'rust',
      \ 'kinds' : [
      \   'T:types,type definitions',
      \   'f:functions,function definitions',
      \   'g:enum,enumeration names',
      \   's:structure names',
      \   'm:modules,module names',
      \   'c:consts,static constants',
      \   't:traits',
      \   'i:impls,trait implementations',
      \]
      \}

" Prevent lines in https://git.io/fpET0 to be run and mingle with ctags for
" rust. This is because `vim-polyglot` loads `vim-rust` only partially.
" Thus, `rust.ctags` is missing in the plugin folder. So, force use of custom
" `$HOME/.ctags`.
let g:rust_use_custom_ctags_defs = 1

" DelimitMate
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" Editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Emmet
"
" Don't use it in normal mode because default prefix <C-y> collides with
" mapping for scrolling the view.
let g:user_emmet_mode = 'i'

" Sprunge
let g:sprunge_open_browser = 1

" Projectionist
let g:projectionist_heuristics = json_decode(join(readfile(expand($DOTVIM . '/misc/projections.json'))))

" Grepper
let g:grepper = {}
let g:grepper.tools = ['rg', 'grep', 'git']
let g:grepper_jump = 1

" Polyglot
let g:polyglot_disabled = ['latex', 'dockerfile']

" Pandoc
let g:pandoc#modules#disabled = ['chdir']

" Vimtex
if has('win32')
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
let r_indent_ess_compatible = 1

" JsDoc
let g:jsdoc_underscore_private = 1
let g:jsdoc_enable_es6 = 1
let g:jsdoc_allow_input_prompt = 0

" Scala
let g:scala_scaladoc_indent = 1

" UltiSnips
let g:UltiSnipsSnippetsDir = expand($DOTVIM . '/misc/UltiSnips')
let g:UltiSnipsSnippetDirectories = [ 'UltiSnips', 'misc/UltiSnips' ]

" Asyncomplete
let g:asyncomplete_remove_duplicates = 0
let g:asyncomplete_smart_completion = 0
let g:asyncomplete_auto_popup = 0

let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

" Disable LSP diagnostics b/c it's dealt with in ALE
let g:lsp_diagnostics_enabled = 0
let g:lsp_signs_enabled = 0
let g:lsp_diagnostics_echo_cursor = 0

" ALE
let g:ale_fixers = {
      \   'javascript': [ 'eslint', 'trim_whitespace', 'remove_trailing_lines' ],
      \   'html': [ 'trim_whitespace', 'remove_trailing_lines' ],
      \ }

let g:ale_fix_on_save = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 7
let g:ale_completion_enabled = 0  " asyncomplete does this

let g:ale_set_highlights = 0
let g:ale_set_signs = 1
let g:ale_sign_warning = '?'
let g:ale_sign_error = '!'
let g:ale_sign_info = 'o'

" Settings {{{1

" To load .vimrc files from current folder. To make sure that these are
" secure, there is a `:set secure` at the of this file.
set exrc

set autowrite
set backspace=indent,eol,start
set cpoptions+=$
set diffopt=filler
set gdefault
set ignorecase
set incsearch
set linebreak
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set modelines=5
set mouse=a
set nobackup
set nojoinspaces
set noshowmode
set nostartofline
set nowrap
set number
set pastetoggle=<f11>
set pumheight=10
set ruler
set shortmess=cat
set showbreak=+
set showmatch
set smartcase
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tags=./tags,./TAGS,tags,TAGS,../tags,../../tags,../../../tags,../../../../tags
set undofile
set updatetime=250
set viminfo=%,'50,:100,<1000
set visualbell
set whichwrap=<,>,h,l
set wildmenu
set wildmode=longest,list,full

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

" formatting
set formatoptions=croq

" Indenting
set shiftround
set expandtab autoindent
set tabstop=2 shiftwidth=2 softtabstop=2

" Spelling
set spelllang=en_us,de_20
set spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/de.utf-8.add

" GVIM and Oni specifics {{{2

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

if exists('g:gui_oni')
  " Override previous configuration with these settings to suit to Oni.
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

" Mappings {{{1

inoremap <C-c> <ESC>
cnoremap <C-c> <ESC>

cnoremap w!! w !sudo tee >/dev/null %

" asyncomplete.vim
imap <C-l> <Plug>(asyncomplete_force_refresh)

" Jump to end of line
inoremap <C-9> <C-o>$

" Jump to beginning of line
inoremap <C-0> <C-o>_

" UPpercase word in insert mode
inoremap <C-p> <esc>mzgUiw`za

nnoremap <space> viw
nnoremap Y y$
nnoremap / /\v

" Delete the buffer, leaving the window open. This overrides 'same as <Tab>'
nnoremap <leader>- :bp\|bd #<cr>

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

" Abolish
nnoremap <leader>ar :%S/<C-r><C-w>/<C-r><C-w>/w<left><left>
nnoremap <leader>as :S//<left>

" Tagbar
nnoremap <leader>tt :TagbarToggle<cr>
nnoremap <leader>to :TagbarOpen fj<cr>
nnoremap <leader>tO :TagbarOpenAutoClose<cr>
nnoremap <leader>tc :TagbarClose<cr>
nnoremap <leader>tp :TagbarTogglePause<cr>

" Obsession
nnoremap <leader>o :Obsession<cr>
nnoremap <leader>O :Obsession!<cr>

" Projectionist
nnoremap <leader>eT :Etest<Space>
nnoremap <leader>ec :Econtroller<Space>
nnoremap <leader>em :Emodel<Space>
nnoremap <leader>es :Esource<Space>
nnoremap <leader>et :Etemplate<Space>
nnoremap <leader>ev :Eview<Space>

" Git branches
nnoremap <leader>b  :Twiggy<cr>
nnoremap <leader>B  :Twiggy<space>
nnoremap <leader>gv :GV<cr>
nnoremap <leader>gV :GV!<cr>

" FZF
nnoremap <silent> <leader>ff :Files<cr>
nnoremap <silent> <leader>fc :Commits<cr>
nnoremap <silent> <leader>fC :BCommits<cr>
nnoremap <silent> <leader>fb :Buffers<cr>

" Grepper
nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)
nnoremap <leader>gg :Grepper -tool rg<cr>
nnoremap <leader>gv :Grepper -tool rg -side<cr>
nnoremap <leader>*  :Grepper -tool rg -cword -noprompt<cr>

" Easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Language servers
nnoremap <leader>lh :LspHover<cr>
nnoremap <leader>lc :LspCodeAction<cr>
nnoremap <leader>ld :LspDefinition<cr>
nnoremap <leader>lD :LspTypeDefinition<cr>
nnoremap <leader>lm :LspDocumentSymbol<cr>
nnoremap <leader>lr :LspReferences<cr>
nnoremap <leader>lR :LspRename<cr>
nnoremap <leader>lf :LspDocumentRangeFormat<cr>
nnoremap <leader>lF :LspDocumentFormat<cr>
nnoremap <leader>ll :LspDocumentDiagnostics<cr>

" Linting
nmap <leader>ef <Plug>(ale_fix)
nmap <leader>el <Plug>(ale_lint)
nmap <leader>ee <Plug>(ale_toggle)
nmap <leader>ed <Plug>(ale_detail)
nmap <leader>er <Plug>(ale_reset)
nmap <silent> <C-n> <Plug>(ale_next_wrap)
nmap <silent> <C-p> <Plug>(ale_previous_wrap)

" Sprunge (disable mapping)
nmap <Plug>DisableSprungeMapping <Plug>Sprunge
xmap <Plug>DisableSprungeMapping <Plug>Sprunge

" UlitSnips
nnoremap <leader>ue :UltiSnipsEdit<cr>

" Vim terminal
if has('nvim')
  tnoremap <C-H> <c-\><c-n><c-w>h
  tnoremap <C-J> <c-\><c-n><c-w>j
  tnoremap <C-K> <c-\><c-n><c-w>k
  tnoremap <C-L> <c-\><c-n><c-w>l

  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-[> <Esc>
  tnoremap <C-v><Esc> <Esc>
endif

" Abbreviations {{{1

" Inserts timestamp (ISO compliant with colon in timezone)
iabbrev aDT <C-R>=strftime("%FT%T%z")<CR><ESC>hi:<ESC>lla

" Expand %% to the current directory
cabbrev <expr> %% expand('%:p:h')

" Filetype-specific autocmds {{{1
"
" This section includes autocomds that change settings and add mappings
" depending on the filetype of the current plugin. I decided to place these
" here instead of $DOTVIM/ftplugin because it allows finer control:
" Overwriting them in .vimrc.local is easier and everything is in one place.

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
  autocmd FileType html normal zR
augroup END

augroup filetype_java
  autocmd!
  autocmd Filetype java let b:ale_fixers = [ 'google_java_format' ]
augroup end

augroup filetype_netrw
  autocmd!
  autocmd FileType netrw setlocal bufhidden=false
augroup END

augroup filetype_rust
  autocmd FileType rust let b:ale_fixers = [ 'rustfmt' ] 
augroup end

augroup filetype_scala
  autocmd!
  autocmd BufWritePost *.scala silent :EnTypeChec
augroup END

augroup filetype_scss
  autocmd!
  autocmd FileType scss let b:ale_fixers = [ 'prettier' ]
augroup end

augroup filetype_sql
  autocmd!
  autocmd FileType sql let &l:formatprg = 'python3 -m sqlparse -k upper -r --indent_width 2 -'
augroup end

augroup filetype_typescript
  autocmd!
  autocmd FileType typescript let b:ale_javascript_prettier_options = '--parser typescript'
  autocmd FileType typescript let b:ale_linters = 'all'
  autocmd FileType typescript let b:ale_fixers  = [ 'prettier', 'tslint', 'eslint', 'trim_whitespace', 'remove_trailing_lines' ]
  autocmd FileType typescript nnoremap <buffer> <leader>lm :JsDoc<cr>
augroup END

augroup filetype_vimrc
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" Language support {{{1

" Language servers {{{2

" vint: -ProhibitAutocmdWithNoGroup

" Typescript:
if executable('typescript-language-server')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript'],
        \ 'priority': 10,
        \ })
endif

" Elixir:
if executable('elixir-language-server')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'elixir-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'elixir-language-server']},
        \ 'whitelist': ['elixir'],
        \ 'priority': 10,
        \ })
endif

" Rust:
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Cargo.toml'))},
        \ 'whitelist': ['rust'],
        \ 'priority': 10,
        \ })
endif

" Java:
"
" This only works with georgewfraser/java-language-server and requires you to
" specify the full path to its `dist/mac/bin` dir, e.g.:
"
"   let g:jls_launcher_dir = expand('/home/niklaas/git/java-language-server/dist/mac/bin')

" for debugging
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')

" This is wrappen in a function to check for `g:jls_launcher_dir`.
function s:register_jls()
  if exists('g:jls_launcher_dir') && isdirectory(expand(g:jls_launcher_dir))
    call lsp#register_server({
          \ 'name': 'java-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, expand(g:jls_launcher_dir) . '/launcher --quiet']},
          \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'pom.xml'))},
          \ 'whitelist': ['java'],
          \ 'priority': 10,
          \ })
  endif
endfunction

if executable('java')
  autocmd User lsp_setup call s:register_jls()
endif

" Completion {{{2

" Files:
autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'whitelist': ['*'],
      \ 'priority': 10,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))

" Snippets {{{2

" Ultisnips:
if has('python3')
  let g:UltiSnipsExpandTrigger='<c-e>'
  autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'priority': 5,
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
endif

" vint: +ProhibitAutocmdWithNoGroup


" Miscellaneous {{{1

" Highlight TODOs etc
" TODO: Define regex for todos and notes a the beginning of this source and
" use them to define two commands :Todo and :Note that use :Grepper to search
" for them. Reuse the regexes below to highlight their occurences.
if has('autocmd')
  if v:version > 701
    augroup highlight_todo
      autocmd!
      autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
      autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
    augroup END
  endif
endif

" Fix highlighting for spell and other highlight groups in terminal
function! s:base16_customize() abort
  " Colors: https://github.com/chriskempson/base16/blob/master/styling.md
  " Arguments: group, guifg, guibg, ctermfg, ctermbg, attr, guisp
  call Base16hi('SpellBad',   '', '', g:base16_cterm08, g:base16_cterm00, '', '')
  call Base16hi('SpellCap',   '', '', g:base16_cterm0A, g:base16_cterm00, '', '')
  call Base16hi('SpellLocal', '', '', g:base16_cterm0D, g:base16_cterm00, '', '')
  call Base16hi('SpellRare',  '', '', g:base16_cterm0B, g:base16_cterm00, '', '')
  call Base16hi('MatchParen', '', '', g:base16_cterm0E, g:base16_cterm00, '', '')
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

" Colors
set t_Co=256
if filereadable(expand('~/.vimrc_background'))
  let base16colorspace=256
  source ~/.vimrc_background
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

" Appearance {{{2

highlight Comment cterm=italic

highlight ALEErrorSign ctermfg=1 ctermbg=18

" TODO: Find out why every sentence-case word at the beginning of a comment
" followed by a colon isn't italic e.g.,
"
"   Foo:
"
" Bar:
"

" .vimrc.local {{{1

" Allows to override settings above for machine specifics
if filereadable(expand('$HOME/.vimrc.local'))
  execute 'source ' . '$HOME/.vimrc.local'
endif

" Not to trust any other .vimrc file loaded via `:set exrc` at the beginning
" of this file.
set secure
