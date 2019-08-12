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
" focus on job.)
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

" Prefix {{{2

call plug#begin('$DOTVIM/plugged')

" Conditional activation for vim-plug plugins
" https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Basics {{{2

Plug 'chilicuil/vim-sprunge'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'jamessan/vim-gnupg'
Plug 'janko/vim-test'
Plug 'sjl/gundo.vim'
Plug 'vim-scripts/dbext.vim'
Plug 'mattn/emmet-vim'

" close brackets et al automagically
Plug 'jiangmiao/auto-pairs'

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
Plug 'tpope/vim-scriptease'  " e.g. map zS for showing sytax group
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'  " for auto-indenting
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'  " for better netrw
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'

" fugitive integrations
Plug 'shumphrey/fugitive-gitlab.vim'

" Git integration
Plug 'sodapopcan/vim-twiggy'
Plug 'junegunn/gv.vim'

" Fuzzy finding
" TODO: try to get rid of this b/c I should navigate through files as
" described at https://vimways.org/2018/death-by-a-thousand-files/
Plug 'junegunn/fzf', Cond(has('unix'), { 'dir': '~/.fzf', 'do': './install --all' })
Plug 'junegunn/fzf.vim', Cond(has('unix'))

Plug 'junegunn/vim-easy-align'

" LSP / completion / snippets
Plug 'prabirshrestha/asyncomplete.vim', Cond(!exists('g:gui_oni') && v:version >= 800)
Plug 'prabirshrestha/async.vim', Cond(!exists('g:gui_oni') && v:version >= 800)

" Snippets
Plug 'SirVer/ultisnips', Cond(!exists('g:gui_oni') && v:version >= 800 && has('python3'))
Plug 'honza/vim-snippets', Cond(!exists('g:gui_oni') && v:version >= 800 && has('python3'))

Plug 'prabirshrestha/vim-lsp', Cond(!exists('g:gui_oni') && v:version >= 800)
Plug 'prabirshrestha/asyncomplete-lsp.vim', Cond(!exists('g:gui_oni') && v:version >= 800)

" Snippet integration with language servers
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'

Plug 'w0rp/ale', Cond(v:version >= 800)

" Syntax rules and filetype specific plugins {{{2

" CSV
Plug 'chrisbra/csv.vim'

Plug 'ekalinin/Dockerfile.vim'

" Polyglot
Plug 'sheerun/vim-polyglot'

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

" Gutentags {{{2

if executable('universal-ctags')
  let g:gutentags_ctags_executable = 'universal-ctags'
endif

" Lightline {{{2
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
      \   'left': [ [ 'filename', 'gitversion', 'modified' ] ],
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

" Tmuxline {{{2
let g:tmuxline_powerline_separators = 0

" Tagbar {{{2
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

" Editorconfig {{{2
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Emmet {{{2

" Don't use it in normal mode because default prefix <C-y> collides with
" mapping for scrolling the view.
let g:user_emmet_mode = 'i'

" Overrides vim's default mapping <C-j> which is the same as <NL> in
" insert mode though. I have not found out what <NL> is for yet, but I
" have the feeling I never use it.
let g:user_emmet_leader_key = '<C-j>'

" Sprunge {{{2
let g:sprunge_open_browser = 1

" Projectionist {{{2
let g:projectionist_heuristics = json_decode(join(readfile(expand($DOTVIM . '/misc/projections.json'))))

" Polyglot {{{2
let g:polyglot_disabled = ['latex', 'dockerfile']

" Prevent lines in https://git.io/fpET0 to be run and mingle with ctags for
" rust. is because `vim-polyglot` loads `vim-rust` only partially.
" Thus, `rust.ctags` is missing in the plugin folder. So, force use of custom
" `$HOME/.ctags`.
let g:rust_use_custom_ctags_defs = 1

" UltiSnips {{{2
let g:UltiSnipsExpandTrigger='<c-e>'
let g:UltiSnipsSnippetsDir = expand($DOTVIM . '/misc/UltiSnips')
let g:UltiSnipsSnippetDirectories = [ 'UltiSnips', 'misc/UltiSnips' ]

" Language awareness (vim-ale and vim-lsp) {{{2

" While vim-lsp is very powerful for providing LSP related features
" such as 'go to definition', ALE offers a more comprehensive feature
" set in regard of linting/diagnostics. Thus, we disable these
" features for vim-lsp.
let g:lsp_signs_enabled = 0
let g:lsp_diagnostics_echo_cursor = 0
let g:lsp_virtual_text_enabled = 0
let g:lsp_highlights_enabled = 0

" That said, the following must be enabled for Code Actions to work.
" Otherwise vim-lsp complains that no diagnostics could be found.
let g:lsp_diagnostics_enabled = 1

" Asyncomplete
let g:asyncomplete_remove_duplicates = 0
let g:asyncomplete_smart_completion = 0
let g:asyncomplete_auto_popup = 0

let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

" ALE
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \   'scss': ['sasslint'],
      \   'vim': ['vint'],
      \ }
let g:ale_fixers = {
      \   'javascript': [ 'prettier', 'eslint', 'trim_whitespace', 'remove_trailing_lines' ],
      \   'html': [ 'trim_whitespace', 'remove_trailing_lines' ],
      \ }

let g:ale_fix_on_save = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 7

" While ALE needs LSPs for linting, it should not use them for
" anything else. So, in the following we disable those features
" vim-lsp is responsible for.
let g:ale_completion_enabled = 0

let g:ale_set_highlights = 0
let g:ale_set_signs = 1
let g:ale_sign_warning = '?'
let g:ale_sign_error = '!'
let g:ale_sign_info = 'o'

" Vim settings {{{1

" To load .vimrc files from current folder. To make sure that these are
" secure, there is a `:set secure` at the of this file.
set exrc

set autowrite
set backspace=indent,eol,start
set clipboard^=unnamed
set cpoptions+=$
set diffopt=internal,filler,algorithm:histogram
set gdefault
set ignorecase
set incsearch
set linebreak
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set modelines=5
set nobackup
set nojoinspaces
set noshowmode
set nowrap
set number
set pumheight=10
set ruler
set shortmess=catOT
set showbreak=+
set showmatch
set smartcase
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tags=./tags,./TAGS,tags,TAGS,../tags,../../tags,../../../tags,../../../../tags
set textwidth=70
set undofile
set updatetime=1000
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
  set grepprg=rg\ --hidden\ --vimgrep
endif

" Oni specifics
if !exists('g:gui_oni')
  augroup responsive_cursorline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup end
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

" General {{{2

inoremap <C-c> <ESC>
cnoremap <C-c> <ESC>

" asyncomplete.vim
imap <C-l> <Plug>(asyncomplete_force_refresh)

nnoremap <space> @q
nnoremap Y y$

" Delete the buffer, leaving the window open. This overrides 'same as <Tab>'
nnoremap <leader>/ :bp\|bd #<cr>
nnoremap gb :ls<CR>:b 

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

nnoremap <leader>cp :let @+ = expand("%")<cr>
nnoremap <leader>cf :let @+ = expand("%:t")<cr>

nnoremap <leader>ve :vsplit $MYREALVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" Yanks current outer paragraph and pastes above
nnoremap <leader>p yapP

" Eases navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <leader>ee :edit **/
nnoremap <leader>es :split **/
nnoremap <leader>ev :vsplit **/
nnoremap <leader>en :next **/
nnoremap <leader>et :edit %<.

nnoremap <leader>ff :find **/
nnoremap <leader>fs :sfind **/
nnoremap <leader>fv :vertical sfind **/

" Plugin related {{{2

" Fuzzy searching

nnoremap <leader><leader> :FZF<cr>
nnoremap <leader>. :Buffers<cr>

" Abolish
nnoremap <leader>ac :cdo S/
nnoremap <leader>ar :%S/<C-r><C-w>/<C-r><C-w>/w<left><left>
nnoremap <leader>as :S/

" Tagbar
nnoremap <leader>tt :TagbarToggle<cr>
nnoremap <leader>to :TagbarOpen fj<cr>
nnoremap <leader>tO :TagbarOpenAutoClose<cr>
nnoremap <leader>tc :TagbarClose<cr>
nnoremap <leader>tp :TagbarTogglePause<cr>

" Obsession
nnoremap <leader>o :Obsession<cr>
nnoremap <leader>O :Obsession!<cr>

" Easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" vim-lsp
nnoremap <leader>lD :LspTypeDefinition<cr>
nnoremap <leader>lF :LspDocumentFormat<cr>
nnoremap <leader>lR :LspRename<cr>
nnoremap <leader>lc :LspCodeAction<cr>
nnoremap <leader>ld :LspDefinition<cr>
nnoremap <leader>lf :LspDocumentRangeFormat<cr>
nnoremap <leader>lh :LspHover<cr>
nnoremap <leader>ll :LspDocumentDiagnostics<cr>
nnoremap <leader>lm :LspDocumentSymbol<cr>
nnoremap <leader>lr :LspReferences<cr>

" vim-ale
nmap <leader>ef <Plug>(ale_fix)
nmap <leader>el <Plug>(ale_lint)
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
  tnoremap <C-c> <C-\><C-n>
  tnoremap <C-[> <Esc>
  tnoremap <C-v><Esc> <Esc>
endif

" Abbreviations {{{1

" Inserts timestamp (ISO compliant with colon in timezone)
iabbrev aDTZ <C-R>=strftime("%FT%T%z")<CR><ESC>hi:<ESC>lla

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
  autocmd FileType gitcommit setlocal comments+=fb:- fo+=nrbl spell
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
  augroup vim_lsp_typescript
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
          \ 'whitelist': ['typescript'],
          \ 'priority': 10,
          \ })
    autocmd FileType typescript setlocal omnifunc=lsp#complete
  augroup END
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
function! s:register_jls()
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

" Miscellaneous {{{1

" Highlight TODOs etc
" TODO: Define regex for todos and notes a the beginning of this
" source and use them to define two commands :Todo and :Note that use
" :grep to search for them. Reuse the regexes below to highlight their
" occurences.
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
  call Base16hi('SpellBad',   '', '', g:base16_cterm08, 'NONE', '', '')
  call Base16hi('SpellCap',   '', '', g:base16_cterm0A, 'NONE', '', '')
  call Base16hi('SpellLocal', '', '', g:base16_cterm0D, 'NONE', '', '')
  call Base16hi('SpellRare',  '', '', g:base16_cterm0B, 'NONE', '', '')
  call Base16hi('MatchParen', '', '', g:base16_cterm0E, 'NONE', '', '')

  " Fix subordinate role of `CursorLine` in nvim
  "
  " refs neovim/neovim#9019
  " refs neovim/neovim#7383
  call Base16hi('Normal',     '', '', '',               'NONE', '', '')
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
