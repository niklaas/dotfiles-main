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

Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'jamessan/vim-gnupg'
Plug 'sjl/gundo.vim'
Plug 'vim-scripts/dbext.vim'
Plug 'mattn/emmet-vim'

" close brackets et al automagically
Plug 'jiangmiao/auto-pairs'

" Navigation
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
Plug 'tpope/vim-rhubarb'  " GitHub

Plug 'junegunn/gv.vim'

" Fuzzy finding
" TODO: try to get rid of this b/c I should navigate through files as
" described at https://vimways.org/2018/death-by-a-thousand-files/
Plug 'junegunn/fzf', Cond(has('unix'), { 'dir': '~/.fzf', 'do': './install --all' })
Plug 'junegunn/fzf.vim', Cond(has('unix'))

Plug 'junegunn/vim-easy-align'

" Snippets
Plug 'SirVer/ultisnips', Cond(!exists('g:gui_oni') && v:version >= 800 && has('python3'))
Plug 'honza/vim-snippets', Cond(!exists('g:gui_oni') && v:version >= 800 && has('python3'))

Plug 'w0rp/ale', Cond(v:version >= 800)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntax rules and filetype specific plugins {{{2

" CSV
Plug 'chrisbra/csv.vim'

Plug 'ekalinin/Dockerfile.vim'

" Polyglot
let g:polyglot_disabled = ['latex', 'dockerfile']
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
let g:gutentags_plus_nomap = 1
let g:gutentags_exclude_filetypes = ['gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git']

" Lightline {{{2
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ],
      \             [ 'gitdiff' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ],
      \              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]
      \            ]
      \ },
      \ 'component_function': {
      \   'obsession': 'LightlineObsession',
      \   'cwd': 'Cwd',
      \   'gitbranch': 'FugitiveHead',
      \   'fileformat': 'LightlineFileformat',
      \   'fileencoding': 'LightlineFileencoding',
      \   'filetype': 'LightlineFiletype',
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
      \ },
      \ 'tabline': {
      \   'right': [ [ 'cwd' ] ]
      \ },
      \ 'mode_map': {
      \   'n' : 'N',
      \   'i' : 'I',
      \   'R' : 'R',
      \   'v' : 'V',
      \   'V' : 'VL',
      \   "\<C-v>": 'VB',
      \   'c' : 'C',
      \   's' : 'S',
      \   'S' : 'SL',
      \   "\<C-s>": 'SB',
      \   't': 'T',
      \ },
      \ }

let g:lightline#ale#indicator_checking = '...'

function! LightlineObsession()
  let l:status = strpart(ObsessionStatus(), 1, 1)
  return l:status ==# '$' ? '$' : ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 120 ? &fileformat : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 120 ? &fileencoding : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 120 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! Cwd()
  " TODO: splitting does not work on Windows with '\'
  let root_dir_as_list = split(getcwd(), '/')[-1:]

  if len(root_dir_as_list) ==# 1
    return root_dir_as_list[0]
  endif

  return ''
endfunction

" Test {{{2

let test#strategy='dispatch'

" Tmuxline {{{2
let g:tmuxline_powerline_separators = 0
let g:tmuxline_theme = 'lightline'
let g:tmuxline_preset = 'minimal'

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
let g:user_emmet_leader_key = '<C-q>'

let g:user_emmet_settings = {
      \ 'typescript' : {
      \   'extends': 'jsx'
      \}
      \}

" Projectionist {{{2
let g:projectionist_heuristics = json_decode(join(readfile(expand($DOTVIM . '/misc/projections.json'))))

" Polyglot {{{2

" Prevent lines in https://git.io/fpET0 to be run and mingle with ctags for
" rust. is because `vim-polyglot` loads `vim-rust` only partially.
" Thus, `rust.ctags` is missing in the plugin folder. So, force use of custom
" `$HOME/.ctags`.
let g:rust_use_custom_ctags_defs = 1

" UltiSnips {{{2
let g:UltiSnipsExpandTrigger='<c-e>'
let g:UltiSnipsSnippetsDir = expand($DOTVIM . '/misc/UltiSnips')
let g:UltiSnipsSnippetDirectories = [ 'UltiSnips', 'misc/UltiSnips' ]


" ALE {{{2
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \   'java': ['pmd'],
      \   'javascript': ['flow', 'eslint'],
      \   'scss': ['stylelint'],
      \   'vim': ['vint'],
      \   'zsh': ['shell', 'shellcheck'],
      \   'terraform': ['terraform']
      \ }
let g:ale_fixers = {
      \   'html': [ 'prettier', 'trim_whitespace', 'remove_trailing_lines' ],
      \   'javascript': [ 'prettier', 'eslint', 'trim_whitespace', 'remove_trailing_lines' ],
      \   'typescriptreact': [ 'prettier' ],
      \   'json': [ 'prettier' ],
      \   'markdown': [ 'remove_trailing_lines' ],
      \   'zsh': [ 'trim_whitespace', 'remove_trailing_lines' ],
      \   'terraform': ['terraform'],
      \   'scss': ['prettier']
      \ }

let g:ale_fix_on_save = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 7

" While ALE needs LSPs for linting, it should not use them for
" anything else. So, in the following we disable those features.
let g:ale_completion_enabled = 0

let g:ale_set_highlights = 0
let g:ale_set_signs = 1
let g:ale_sign_warning = '?'
let g:ale_sign_error = '!'
let g:ale_sign_info = 'o'

" Vim settings {{{1

set autowrite
set backspace=indent,eol,start
set clipboard^=unnamedplus
set cpoptions+=$
set diffopt=internal,filler,context:3
set gdefault
set hidden
set ignorecase
set incsearch
set linebreak
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set modelines=5
set mouse=a
set nobackup
set nohlsearch
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
set undofile
set updatetime=300
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
  set grepprg=rg\ --vimgrep
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

nnoremap <leader><space> @q
nnoremap Y y$
nnoremap gb :ls<CR>:b 

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

nnoremap <leader>cp :let @+ = expand("%")<cr>
nnoremap <leader>cf :let @+ = expand("%:t")<cr>
nnoremap <leader>cP :let @+ = expand("%")   . ':' . line('.') . ':' . col('.')<cr>
nnoremap <leader>cF :let @+ = expand("%:t") . ':' . line('.') . ':' . col('.')<cr>

nnoremap <leader>ve :vsplit $MYREALVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" Yanks current outer paragraph and pastes above
nnoremap <leader>p yapP

if executable('xi')
  nnoremap <leader>i :w !xi<cr>
  vnoremap <leader>i :w !xi<cr>
endif

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
nnoremap <leader>/ :FZF<space>

" Abolish
nnoremap <leader>ac :cdo S/
nnoremap <leader>ar :%S/<C-r><C-w>/<C-r><C-w>/w<left><left>
nnoremap <leader>as :S/

" Sneak
map f <Plug>Sneak_s
map F <Plug>Sneak_S

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

" Coc.nvim
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> <leader>la <Plug>(coc-codeaction)
nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>lf <Plug>(coc-fix-current)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>ln <Plug>(coc-rename)
nmap <silent> <leader>lr <Plug>(coc-references)
nmap <silent> <leader>lt <Plug>(coc-type-definition)

nnoremap <silent> <leader>lo :<C-u>CocList outline<cr>
nnoremap <silent> <leader>ls :<C-u>CocList -I symbols<cr>

nnoremap <silent> K :call <SID>show_documentation()<CR>

inoremap <silent><expr> <C-l> coc#refresh()

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" vim-ale
nmap <leader>ef <Plug>(ale_fix)
nmap <leader>el <Plug>(ale_lint)
nmap <leader>ed <Plug>(ale_detail)
nmap <leader>er <Plug>(ale_reset)

" UlitSnips
nnoremap <leader>ue :UltiSnipsEdit<cr>

" Vim terminal
if has('nvim')
  tnoremap <C-H> <c-\><c-n><c-w>h
  tnoremap <C-J> <c-\><c-n><c-w>j
  tnoremap <C-K> <c-\><c-n><c-w>k
  tnoremap <C-L> <c-\><c-n><c-w>l

  let $GIT_EDITOR = 'nvr -cc split --remote-wait'

  augroup nvr_git
    autocmd!
    autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
  augroup END

  augroup term_insert
    autocmd!
    autocmd TermOpen term://* startinsert
  augroup END
endif

" Commands {{{1

if !exists(':BD')
  command BD :bp\|bd #<cr>
endif

if !exists(':BW')
  command BW :bp\|bw #<cr>
endif

" Abbreviations {{{1

" Inserts timestamp (ISO compliant with colon in timezone)
iabbrev aT <C-R>=strftime("%FT%T%z")<CR><ESC>hi:<ESC>lla
iabbrev aD <C-R>=strftime("%F (%V-%u)")<CR>

" Expand %% to the current directory
cabbrev <expr> %% expand('%:p:h')

" autocmds {{{1

" automagic marks {{{2

augroup automagic_marks
  autocmd!
  autocmd BufLeave *.css,*.scss normal! mC
  autocmd BufLeave *.html       normal! mH
  autocmd BufLeave *.ts,*.tsx   normal! mT
  autocmd BufLeave *.js,*.jsx   normal! mS
  autocmd BufLeave *.java       normal! mJ
augroup END

augroup filename_MERGEREQU_EDITMSG
  autocmd!
  autocmd BufEnter .git/MERGEREQ_EDITMSG set filetype=gitcommit
augroup END

" Filetype-specific autocmds {{{2
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
  autocmd FileType netrw setlocal bufhidden=delete
augroup END

augroup filetype_markdown
  autocmd!
  autocmd FileType markdown setlocal comments=b:>,fb:-,fb:* textwidth=80 fo+=c
  " The following fixes additional indentation in the subsequent lines of
  " lists
  "
  " https://github.com/plasticboy/vim-markdown/issues/126#issuecomment-485579068
  autocmd FileType markdown setlocal indentexpr=
augroup END

augroup filetype_rust
  autocmd FileType rust let b:ale_fixers = [ 'rustfmt' ] 
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

" followed by a colon isn't italic e.g.,
"
"   Foo:
"
" Bar:
"

" Project-specifics {{{1

augroup project_specifics
  autocmd FileType */mk-site/*.html let b:ale_fixers = []
augroup end

" .vimrc.local {{{1

" Allows to override settings above for machine specifics
if filereadable(expand('$HOME/.vimrc.local'))
  execute 'source ' . '$HOME/.vimrc.local'
endif
