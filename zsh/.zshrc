# Init {{{1

# Plugins {{2
if command -v antibody >/dev/null 2>&1
then
    # Fixes for oh-my-zsh, see https://github.com/getantibody/antibody/issues/218
    DISABLE_AUTO_UPDATE=true
    ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

    source <(antibody init)
    antibody bundle < ~/.zsh_plugins.txt
else
    echo 'Please install antibody.'
fi

# Checks {{2
if ! find /usr/share/terminfo -type f -name tmux-256color >/dev/null
then
    echo "terminfo tmux-256color probably not available"
    echo "this will most likely result in misbehaviour"
    echo "install ncurses-term"
fi

# General {{{1

typeset -U path
path=(~/.local/bin ~/go/bin ~/n/bin ~/.cargo/bin /snap/bin /opt/local/bin /opt/local/libexec/gnubin $path)
typeset -U fpath
fpath=(~/.local/share/zsh/functions/Completion $fpath)

autoload -U zmv  # zsh's bulk renaming
autoload -U is-at-least
autoload -U compdef
autoload -U zcalc

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

# Local configuration available?
test -f ${HOME}/.zshrc.local && source ${HOME}/.zshrc.local

bindkey -v
bindkey -v '^a' vi-beginning-of-line
bindkey -v '^e' vi-end-of-line

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey -M vicmd v edit-command-line

bindkey -s '^z' 'fg\n'

if ! command -v fzf >/dev/null 2>&1
then
    bindkey '^R' history-incremental-pattern-search-backward
    bindkey '^P' vi-up-line-or-history
    bindkey '^N' vi-down-line-or-history
fi

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Aliases {{{1

# Normal Aliases {{{2
alias e=$EDITOR
alias es="$EDITOR -S Session.vim"
alias er="$EDITOR -R"
alias se="sudo -e"
alias v="vim"
alias nv="nvim"

alias a="apt"
alias auu="sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y"

alias d="dirs -v"

alias dt="date +%Y%m%d_%H%M%S"
alias dti="date +%FT%T"
alias dts="date +%Y-%m-%d"

alias feh="feh -Z"

alias g="git"

alias j="just"

alias kcgpg="keychain -q --eval 1C62D5F3 >/dev/null"
alias kcrn="keychain -q --eval rsync.net >/dev/null"

alias less="less -R"
alias ls="ls --color"
alias l="ls -lFah"

alias mcssh="cssh -C .clusterssh/config_mosh"

alias mmv="noglob zmv -W"

alias p="parallel"

alias pc="pass -c"
alias pg="pwgen -ys"

alias ra="rsync -a"

alias rs="rsync"
alias srn="ssh rsync.net"
alias tree="tree --charset=ascii"

alias sst="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET"

# Global Aliases {{{2

alias -g C="| xsel -b"
alias -g F="| fzf"
alias -g G="| grep -i"
alias -g H="| head"
alias -g L="| less"
alias -g S="| sort"
alias -g SV="| sort -V"
alias -g T="| tail"
alias -g X="| xargs"

alias -g V="\$(xclip -out -selection primary)"
alias -g P="\$(xclip -out -selection clipboard)"

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
    DIDDIR=~/notes
    DIDFILE=$DIDDIR/$(date +%Y-%V).md

    if [ ! -d "$DIDIR" ]; then
        mkdir -p "$DIDDIR"
    fi

    if [ ! -f "$DIDFILE" ]; then
        date +'# %F (%V-%u)' > $DIDFILE
        echo "\n" >> $DIDFILE
        $EDITOR +'normal G' +startinsert $DIDFILE

        exit 0
    fi

    LAST_MODIFIED=$(stat -c %y "$DIDFILE")

    if [ "${LAST_MODIFIED:0:10}" != "$(date +%F)" ]; then
        echo >> $DIDFILE
        date +'# %F (%V-%u)' >> $DIDFILE
    fi

    echo "\n" >> $DIDFILE
    $EDITOR +'normal G' +startinsert $DIDFILE
}

# Others {{{2

function my_man {
    $EDITOR +"Man $1|on"
}
alias man="my_man"

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

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

if [ ! -f $HOME/.base16_theme ]
then
    command -v base16_default-dark && base16_default-dark
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vim:set foldmethod=marker:
