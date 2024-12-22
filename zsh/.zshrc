# Init {{{1

# Colors {{2

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

# Homebrew {{{3
eval $(/opt/homebrew/bin/brew shellenv)

typeset -U fpath
fpath=(~/.local/share/zsh/functions/Completion $fpath)

# FZF {{{2
if command -v fd >/dev/null 2>&1
then
    export FZF_DEFAULT_OPTS="--bind=ctrl-j:accept"
    export FZF_DEFAULT_COMMAND="fd --unrestricted -E .git -E .svn --type f"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# EDITOR {{{2

export NVIM_APPNAME=nvchad
export VISUAL=nvim

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  export VISUAL=nvr
fi

export FCEDIT=$VISUAL

## Plugins {{{2
ANTIDOTE=/opt/homebrew/opt/antidote/share/antidote/antidote.zsh
if [ -f $ANTIDOTE ]
then
    source $ANTIDOTE
    antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
else
    echo 'Please install antidote.'
fi

## Checks {{{2
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
autoload -U is-at-least # for checking the zsh version
autoload -U compdef
autoload -U zcalc
autoload -U edit-command-line

autoload -Uz compinit
compinit

# Use insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Use a menu for tab completion
zstyle ':completion:*' menu select

HISTFILE=${HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt inc_append_history

# Allow interactive comments to prevent an error when canceling the insertion
# of a command with Alt-# or Escape-# on Mac OS.
setopt interactivecomments

setopt histignorespace

# Configuring the directory stack
# See http://zsh.sourceforge.net/Intro/intro_6.html
DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome

bindkey -v
bindkey -v '^a' vi-beginning-of-line
bindkey -v '^e' vi-end-of-line
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey -s '^z' 'fg\n'

# GPG agent {{{2

eval $(gpg-agent --daemon --allow-preset-passphrase --quiet >/dev/null 2>&1)

# Yubikey {{{2

export SSH_ASKPASS=/opt/homebrew/bin/pinentry-mac

eval $(keychain --eval --agents ssh --quiet id_ed25519)
eval $(
  DISPLAY=:0 \
  SSH_ASKPASS=$HOME/bin/yubikey-askpass \
  keychain --eval --agents ssh --quiet otus_sk
)

# Aliases {{{1

# Normal Aliases {{{2
alias dark=base16_tomorrow-night
alias light=base16_tomorrow

# Editor
alias e=$VISUAL
alias es="$VISUAL -S Session.vim"
alias er="$VISUAL -R"
alias eg="$VISUAL +G +on"
alias se="sudo -e"

ef() {
    e $(fzf) $*
}

# Debian
alias a="apt"
alias auu="sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y"

command -v uctags >/dev/null && \
    alias ctags=uctags

alias curltime="curl -w \"@$HOME/.curl-format.txt\" -o /dev/null -s "

# History
alias dh="dirs -v"
alias h="fc -rl 1 | awk '!seen[\$2]++' | sort -n | grep"

alias d=docker
alias dk="docker compose"

alias dt="date +%Y%m%d_%H%M%S"
alias dti="date +%FT%T"
alias dts="date +%Y-%m-%d"

alias feh="feh -Z"
alias g="git"
alias j="just"

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

# Global Aliases {{{2

alias -g D="*(/)"
alias -g F="| fzf -m" # -m for multi-selection
alias -g G="| grep -i"
alias -g H="| head"
alias -g HL="--help | less"
alias -g L="| less"
alias -g P="| parallel"
alias -g S="| sort"
alias -g T="| tail"
alias -g X="| xargs"

# TODO: Linux only, probably removable:
alias -g C="| xsel -b"
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

NOTESDIR=~/Documents/Notes

function did() {
    DIDDIR=$NOTESDIR/${1+-$1}
    DIDFILE=$DIDDIR/$(date +%Y-%V).md

    if [ ! -d "$DIDIR" ]; then
        mkdir -p "$DIDDIR"
    fi

    if [ ! -f "$DIDFILE" ]; then
        date +'# %F (%V-%u)' > $DIDFILE
        $VISUAL +'normal G' $DIDFILE

        exit 0
    fi

    # For Linux:
    #LAST_MODIFIED=$(stat -c %y "$DIDFILE")

    # For Mac OS:
    LAST_MODIFIED=$(stat -f %Sm -t "%Y-%m-%d")

    if [ "${LAST_MODIFIED:0:10}" != "$(date +%F)" ]; then
        echo >> $DIDFILE
        date +'# %F (%V-%u)' >> $DIDFILE
    fi

    $VISUAL +'normal G' $DIDFILE
}

function todo() {
    grep -HR -- '- \[ \]' $NOTESDIR | sed 's|.*/||' | column -ts :
}

function sketch() {
    SKETCHDIR=$NOTESDIR/${1+-$1}
    SKETCHFILE=$SKETCHDIR/sketch.md

    if [ ! -d "$DIDIR" ]; then
        mkdir -p "$DIDDIR"
    fi

    $VISUAL +'normal G' $SKETCHFILE
}

# Others {{{2

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

# IntelliJ terminal compatibility {{{2

if [ "$TERMINAL_EMULATOR" = "JetBrains-JediTerm" ]
then
    unalias ls # --color breaks completion dialog
fi

# Sourcing {{{2

# asdf
. "$(brew --prefix asdf)/libexec/asdf.sh"

if command -v kubectl >/dev/null
then
    source <(kubectl completion zsh)
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Disable pausing terminal output to make Ctrl-S available when browsing
# through the history using Ctrl-R and Ctrl-S
stty -ixon

# vim:set foldmethod=marker:
