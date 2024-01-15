# Init {{{1

# colors {{2

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    eval "$("$BASE16_SHELL/profile_helper.sh")"

# PATH {{{2
typeset -U path
path=(~/.local/bin ~/go/bin ~/n/bin ~/.cargo/bin $path)
if test -d /usr/local/go/bin
then
    # Looks like golang was installed from upstream directly.
    path=(/usr/local/go/bin $path)
fi

TEXLIVE_DIR=/Library/TeX/texbin
if [ -d $TEXLIVE_DIR ]
then
    path=($TEXLIVE_DIR $path)
fi

if [ ! -d "$HOME/.nvm" ]
then
    mkdir "$HOME/.nvm"
fi

# homebrew {{{3
eval $(/opt/homebrew/bin/brew shellenv)

typeset -U fpath
fpath=(~/.local/share/zsh/functions/Completion $fpath)

PYTHON_BIN=~/Library/Python/3.8/bin
if [ -d $PYTHON_BIN ]; then
  path=($PYTHON_BIN $path)
fi

# FZF {{{2
if command -v fd >/dev/null 2>&1
then
    export FZF_DEFAULT_OPTS="--bind=ctrl-j:accept"
    export FZF_DEFAULT_COMMAND="fd -H -E .git -E .svn --type f"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# EDITOR {{{2

export VISUAL=nvim

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  export VISUAL=nvr
fi

export FCEDIT=$VISUAL

# Plugins {{{2
ANTIDOTE=/opt/homebrew/opt/antidote/share/antidote/antidote.zsh
if [ -f $ANTIDOTE ]
then
    source $ANTIDOTE
    antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
else
    echo 'Please install antidote.'
fi

# Checks {{{2
if ! find /usr/share/terminfo -type f -name tmux-256color >/dev/null
then
    echo "terminfo tmux-256color probably not available"
    echo "this will most likely result in misbehaviour"
    echo "install ncurses-term"
fi

if ! command -v starship >/dev/null 2>&1; then
    echo "starship is not installed"
    echo "please install it otherwise you will"
    echo "get an ugly prompt"
fi

if ! command -v eza >/dev/null; then
    echo "exa is not installed but you like it"
fi

if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
fi

# General {{{1

autoload -U zmv  # zsh's bulk renaming
autoload -U is-at-least
autoload -U compdef
autoload -U zcalc
autoload -U edit-command-line

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

HISTFILE=${HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
unsetopt append_history
unsetopt share_history
setopt inc_append_history_time

# Allow interactive comments to prevent an error when canceling the insertion
# of a command with Alt-#.
setopt interactivecomments

# Configuring the directory stack
# See http://zsh.sourceforge.net/Intro/intro_6.html
DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome

bindkey -v
bindkey -v '^a' vi-beginning-of-line
bindkey -v '^e' vi-end-of-line

bindkey -s '^z' 'fg\n'

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Aliases {{{1

# Normal Aliases {{{2
alias dark=base16_tomorrow-night
alias light=base16_tomorrow

alias e=$VISUAL
alias es="$VISUAL -S Session.vim"
alias er="$VISUAL -R"
alias eg="$VISUAL +G +on"
alias se="sudo -e"
alias v="vim"
alias nv="nvim"

alias a="apt"
alias auu="sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y"

command -v uctags >/dev/null && \
    alias ctags=uctags

alias curltime="curl -w \"@$HOME/.curl-format.txt\" -o /dev/null -s "

alias d="dirs -v"

alias dt="date +%Y%m%d_%H%M%S"
alias dti="date +%FT%T"
alias dts="date +%Y-%m-%d"

alias feh="feh -Z"

alias g="git"
alias h="history | grep"

alias j="just"

alias kcgpg="keychain -q --eval 1C62D5F3 >/dev/null"
alias kcrn="keychain -q --eval rsync.net >/dev/null"

alias less="less -R"

alias ls="ls --color"
alias l="ls -lFah"

if command -v eza >/dev/null; then
    alias l="eza"
    alias ll="eza -l --git"
    alias la="eza -al --git"
    alias lt="eza -T --git"
    alias lts="eza -aT --git"
fi

alias mcssh="cssh -C .clusterssh/config_mosh"

alias mmv="noglob zmv -W"

alias p="parallel"

alias pc="pass -c"
alias pg="pwgen -ys"

alias ra="rsync -a"
alias rs="rsync"
alias srn="ssh rsync.net"

command -v gsed >/dev/null && \
    alias sed=gsed

alias t="tree --charset=ascii"

alias sst="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET"

alias webstorm=open\ -na\ "WebStorm.app"\ --args\ "$@"

# Global Aliases {{{2

alias -g C="| xsel -b"
alias -g D="*(/)"
alias -g F="| fzf -m"
alias -g G="| grep -i"
alias -g H="| head"
alias -g HL="--help | less"
alias -g L="| less"
alias -g P="| parallel"
alias -g S="| sort"
alias -g T="| tail"
alias -g X="| xargs"
alias -g Y="| yank"

# Functions {{{2

bcp() {
    cp -a $1{,.bak-$(dt)}
}

# Overrides {{{2

if command -v gpg2 >/dev/null 2>&1
then
    alias gpg="gpg2"
fi

if command -v gopass >/dev/null 2>&1
then
    alias pass="gopass"
fi

if command -v universal-ctags >/dev/null 2>&1
then
    alias ctags="universal-ctags"
fi

# Removes aliases from oh-my-zsh/common-aliases that conflict with `fd`, an
# alternative for `find` written in Rust
type fd | grep alias >/dev/null 2>&1 && unalias fd
type ff | grep alias >/dev/null 2>&1 && unalias ff

# Specials {{{1

# ix.io {{{2

if ! command -v ix >/dev/null 2>&1
then
    echo 'Downloading client for ix.io...'
    curl -sS ix.io/client > ~/.local/bin/ix
    chmod +x ~/.local/bin/ix
fi

# Update $DISPLAY automagically {{{2
if [ -n "$TMUX" ]; then
    function refresh {
        export DISPLAY="$(tmux show-environment | sed -n 's/^DISPLAY=//p')"
    }
else
    function refresh {}
fi

function preexec {
    refresh
}

# did.md for taking notes {{{2

function did() {
    DIDDIR=~/notes${1+-$1}
    DIDFILE=$DIDDIR/$(date +%Y-%V).md

    if [ ! -d "$DIDIR" ]; then
        mkdir -p "$DIDDIR"
    fi

    if [ ! -f "$DIDFILE" ]; then
        date +'# %F (%V-%u)' > $DIDFILE
        $VISUAL +'normal G' $DIDFILE

        exit 0
    fi

    # is `stat -c` on linux operating systems
    LAST_MODIFIED=$(stat -f %y "$DIDFILE")

    if [ "${LAST_MODIFIED:0:10}" != "$(date +%F)" ]; then
        echo >> $DIDFILE
        date +'# %F (%V-%u)' >> $DIDFILE
    fi

    $VISUAL +'normal G' $DIDFILE
}

function sketch() {
    SKETCHDIR=~/notes${1+-$1}
    SKETCHFILE=$SKETCHDIR/sketch.md

    if [ ! -d "$DIDIR" ]; then
        mkdir -p "$DIDDIR"
    fi

    $VISUAL +'normal G' $SKETCHFILE
}

# Others {{{2

function n {
    if [ "x$1" = "x" ]; then
        e $HOME/Desktop/notes.md
        return 0
    fi

    e $HOME/Desktop/$1.notes.md
}

function my_sudo {
    while [[ $# > 0 ]]; do
        case "$1" in
        command) shift ; break ;;
        nocorrect|noglob) shift ;;
        *) break ;;
        esac
    done
    if [[ $# = 0 ]]; then
        command sudo zsh
    else
        noglob command sudo $@
    fi
}
alias sudo="my_sudo " # makes aliases pass from local user to root

function take() {
    mkdir -p $1 && cd $_
}

if [ -f "/usr/local/bin/lesspipe.sh" ]
then
    LESSOPEN="|/usr/local/bin/lesspipe.sh %s"; export LESSOPEN
fi

if [ -f $HOME/.dir_colors ]
then
    command -v dircolors >/dev/null && eval $(dircolors $HOME/.dir_colors)
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source rbenv
command -v rbenv >/dev/null && eval "$(rbenv init -)"

# Source pyenv

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Local configuration available?
test -f ${HOME}/.zshrc.local && source ${HOME}/.zshrc.local

eval "$(starship init zsh)"

# jeffreytse/zsh-vi-mode
function zvm_config() {
    ZVM_VI_EDITOR=$VISUAL
}

function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

# Sourcing {{{2

if command -v kubectl >/dev/null
then
    source <(kubectl completion zsh)
fi

if [ -f $HOME/.zshrc_local ]
then
    source $HOME/.zshrc_local
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Disable pausing terminal output to make Ctrl-S available
stty -ixon

# vim:set foldmethod=marker:
