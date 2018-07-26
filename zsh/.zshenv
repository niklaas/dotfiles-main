typeset -U path
path=(~/bin ~/go/bin ~/n/bin $path)

autoload -U zmv  # zsh's bulk renaming
autoload -U is-at-least
autoload -U compdef

export SHELL=$(command -v zsh)
export HOSTNAME=$(hostname)

# FZF
if command -v fd >/dev/null 2>&1
then
    export FZF_DEFAULT_COMMAND='fd -H -E .git -E .svn --type f'
fi

# EDITOR setup
if command -v nvim >/dev/null 2>&1
then
    export EDITOR=nvim
else
    export EDITOR=vim
fi
alias e=$EDITOR
alias v="vim"
alias vv="vim -MR -c 'file [stdin]' -"
alias nv="nvim"
alias nvv="nvim -MR -c 'file [stdin]' -"

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_COLLATE=C

# Simplifies prompt symbole for pure prompt
export PURE_PROMPT_SYMBOL='>'

if test -d /usr/local/go/bin
then
    # Looks like golang was installed from upstream directly.
    path=(/usr/local/go/bin $path)
fi
export GOPATH=$HOME/go

export N_PREFIX=$HOME/n

export ANSIBLE_NOCOWS=1

export MOSH_TITLE_NOPREFIX="YES"
export PARINIT="rTbgqR B=.,?_A_a Q=_s>|"

export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# Export default TERMINAL
if command -v uxterm >/dev/null 2>&1
then
    export TERMINAL="uxterm"
elif command -v xterm >/dev/null 2>&1
then
    export TERMINAL="xterm"
fi

alias a="apt"

alias d="dirs -v"

alias dt="date +%Y%m%d_%H%M%S"
alias dti="date +%FT%T"
alias dts="date +%Y-%m-%d"

alias g="git"

if command -v gpg2 >/dev/null 2>&1
then
    alias gpg="gpg2"
fi

alias kcgpg="keychain -q --eval 1C62D5F3 >/dev/null"
alias kcrn="keychain -q --eval rsync.net >/dev/null"

alias less="less -R"
alias ls="ls --color"

alias mcssh="cssh -C .clusterssh/config_mosh"

alias ra="rsync -a"

alias rs="rsync"
alias srn="ssh rsync.net"
alias tree="tree --charset=ascii"

alias tssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET"

alias -g S="| curl -F 'sprunge=<-' http://sprunge.us"

if command -v xclip >/dev/null 2>&1
then
    alias -g C="| xclip -sel clip"
fi

if command -v rem >/dev/null 2>&1
then
    alias remm="rem -c -m"
    alias remw="rem -c+ -m"
    alias remwn="rem -c+ -m $(date  +%d\ %b\ %Y --date='next week')"
    alias remmn="rem -c -m $(date  +%b\ %Y --date='next month')"
    alias remtm="rem -g -q $(date  +%d\ %b\ %Y --date='tomorrow')"
    alias remtd="rem -g -q"
fi

if command -v gopass >/dev/null 2>&1
then
    alias pass="gopass"
fi

# FreeBSD specific ###################################################

if uname -a | grep -q FreeBSD
then
    jails=/usr/local/jails
    pdir=/usr/local/etc/poudriere.d
    letc=/usr/local/etc

    alias je="sudo jexec"
    alias jl="jls | cut -f 2 -w | tail +2"
fi

# WSL specific #######################################################

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

# Hostname specific ##################################################

if echo "$HOSTNAME" | grep -q 'niklaas.eu'
then
    alias cs="sudo csync2 -N $(hostname -s).klaas"
fi

# Specials ###########################################################

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
