typeset -U path
path=(~/.local/bin ~/go/bin ~/n/bin ~/.cargo/bin $path)
typeset -U fpath
fpath=(~/.local/share/zsh/functions/Completion $fpath)

autoload -U zmv  # zsh's bulk renaming
autoload -U is-at-least
autoload -U compdef

autoload -Uz compinit
compinit

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_COLLATE=C

export DISPLAY=:0.0
export SHELL=$(command -v zsh)
export HOSTNAME=$(hostname)
export GPG_TTY=$(tty)

# EDITOR setup
LOCAL_NVIM=~/.local/bin/nvim
if [ -f $LOCAL_NVIM -o -L $LOCAL_NVIM ]
then
    # Looks like nvim was built from source
    export EDITOR=$LOCAL_NVIM
    alias nvim=$LOCAL_NVIM
elif command -v nvim >/dev/null 2>&1
then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# Go
if test -d /usr/local/go/bin
then
    # Looks like golang was installed from upstream directly.
    path=(/usr/local/go/bin $path)
fi
export GOPATH=$HOME/go

# Texlive
TEXLIVE_DIR=~/.local/texlive/2018
if [ -d $TEXLIVE_DIR ]
then
    path=($TEXLIVE_DIR/bin/x86_64-linux $path)
fi

export N_PREFIX=$HOME/n

export ANSIBLE_NOCOWS=1

export MOSH_TITLE_NOPREFIX="YES"
export PARINIT="rTbgqR B=.,?_A_a Q=_s>|"

# FZF
if command -v fd >/dev/null 2>&1
then
    export FZF_DEFAULT_COMMAND="fd -H -E .git -E .svn --type f"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Export default TERMINAL
if command -v uxterm >/dev/null 2>&1
then
    export TERMINAL="uxterm"
elif command -v xterm >/dev/null 2>&1
then
    export TERMINAL="xterm"
fi

# Aliases {{{1

alias e=$EDITOR
alias es="$EDITOR -S Session.vim"
alias er="$EDITOR -R"
alias v="vim"
alias nv="nvim"

alias a="apt"

alias d="dirs -v"

alias dt="date +%Y%m%d_%H%M%S"
alias dti="date +%FT%T"
alias dts="date +%Y-%m-%d"

alias g="git"

alias kcgpg="keychain -q --eval 1C62D5F3 >/dev/null"
alias kcrn="keychain -q --eval rsync.net >/dev/null"

alias less="less -R"
alias ls="ls --color"

alias mcssh="cssh -C .clusterssh/config_mosh"

alias pc="pass -c"

alias ra="rsync -a"

alias rs="rsync"
alias srn="ssh rsync.net"
alias tree="tree --charset=ascii"

alias tssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET"

alias -g S="| sort"
alias -g SV="| sort -V"

alias -g C="| xsel -b"

# Overrides {{{2

if command -v gpg2 >/dev/null 2>&1
then
    alias gpg="gpg2"
fi

if command -v gopass >/dev/null 2>&1
then
    alias pass="gopass"
fi

# FreeBSD specific {{{1

if uname -a | grep -q FreeBSD
then
    jails=/usr/local/jails
    pdir=/usr/local/etc/poudriere.d
    letc=/usr/local/etc

    alias je="sudo jexec"
    alias jl="jls | cut -f 2 -w | tail +2"
fi

# WSL specific {{{1

if uname -a | grep -q Microsoft
then
    umask 022

    alias docker="docker.exe"
    alias java="java.exe"

    export DISPLAY=:0

    # Java environment on Windows
    export JAVA_HOME="/mnt/c/Program Files/Java/jre1.8.0_151"
    export JDK_HOME="/mnt/c/Program Files/Java/jdk1.8.0_144"

    export GPG_TTY=$(tty)

    function pwdd() {
        pwd -P | sed 's#/mnt/\([a-zA-Z]\)#\U\1:#'
    }

    alias -g C="| clip.exe"
fi

# Hostname specific {{{1

if echo "$HOSTNAME" | grep -q 'niklaas.eu'
then
    alias cs="sudo csync2 -N $(hostname -s).klaas"
fi

# Specials {{{1

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

if [ ! -f $HOME/.base16_theme ]
then
    command -v base16_default-dark && base16_default-dark
fi

# vim:set foldmethod=marker:
