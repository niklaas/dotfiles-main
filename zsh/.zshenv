typeset -U path
path=(~/bin ~/go/bin ~/n/bin $path)

autoload -U zmv  # zsh's bulk renaming

export SHELL=$(command -v zsh)
export EDITOR=vim
export HOSTNAME=$(hostname)

export GOPATH=$HOME/go
export N_PREFIX=$HOME/n

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_COLLATE=C

export MOSH_TITLE_NOPREFIX="YES"
export PARINIT="rTbgqR B=.,?_A_a Q=_s>|"

export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# Simplifies prompt symbole for pure prompt
export PURE_PROMPT_SYMBOL='>'

# Export default TERMINAL
if command -v uxterm >/dev/null 2>&1
then
    export TERMINAL="uxterm"
elif command -v xterm >/dev/null 2>&1
then
    export TERMINAL="xterm"
fi

alias a="apt"

alias dt="date +%Y%m%d_%H%M%S"
alias dti="date +%FT%T"
alias dts="date +%Y-%m-%d"

alias g="git"

alias kcgpg="keychain -q --eval 1C62D5F3 >/dev/null"
alias kcrn="keychain -q --eval rsync.net >/dev/null"

alias mcssh="cssh -C .clusterssh/config_mosh"

alias ra="rsync -a"

alias rs="rsync"
alias srn="ssh rsync.net"
alias tree="tree --charset=ascii"

alias v="vim --servername vim"
alias vv="vim -MR -c 'file [stdin]' -"

alias -g S="| curl -F 'sprunge=<-' http://sprunge.us"

if command -v rem >/dev/null 2>&1
then
    alias remm="rem -c -m"
    alias remw="rem -c+ -m"
    alias remwn="rem -c+ -m $(date  +%d\ %b\ %Y --date='next week')"
    alias remmn="rem -c -m $(date  +%b\ %Y --date='next month')"
    alias remtm="rem -g -q $(date  +%d\ %b\ %Y --date='tomorrow')"
    alias remtd="rem -g -q"
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
