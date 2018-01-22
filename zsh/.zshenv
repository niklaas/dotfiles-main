# PATH
typeset -U path
path=(~/bin ~/go/bin ~/n/bin $path)

if [ -f $HOME/.dir_colors ]
then
    command -v dircolors >/dev/null && eval $(dircolors $HOME/.dir_colors)
fi

# Ensures that the chosen base16 theme propagates correctly
if [ ! -f $HOME/.base16_theme ]
then
    command -v base16_default-dark && base16_default-dark
fi

# ZSH modules
autoload -U zmv         # loads zmv for bulk renaming

# Variables
jails=/usr/local/jails
pdir=/usr/local/etc/poudriere.d
letc=/usr/local/etc

# Exports
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

# Normal aliases
alias a="aptitude"
alias aria2cd="aria2c --enable-rpc --rpc-listen-all"
alias dt="date +%Y%m%d_%H%M%S"
alias dti="date +%FT%T"
alias dts="date +%Y-%m-%d"
alias gsu="git submodule update --recursive --remote"
alias je="sudo jexec"
alias jl="jls | cut -f 2 -w | tail +2"
alias kcgpg="keychain -q --eval 1C62D5F3 >/dev/null"
alias kcrn="keychain -q --eval rsync.net >/dev/null"
alias mcssh="cssh -C .clusterssh/config_mosh"
alias mpvdf="mpv --playlist=http://www.dradio.de/streaming/dlf_hq_ogg.m3u"
alias mpvdk="mpv --playlist=http://www.dradio.de/streaming/dkultur_hq_ogg.m3u"
alias mpvdw="mpv --playlist=http://www.dradio.de/streaming/dradiowissen_hq_ogg.m3u"
alias ra="rsync -a"
alias remm="rem -c -m"
alias remw="rem -c+ -m"
alias rs="rsync"
alias srn="ssh rsync.net"
alias tree="tree --charset=ascii"
alias v="vim --servername vim"
alias vv="vim -MR -c 'file [stdin]' -"

# Global aliases
alias -g S="| curl -F 'sprunge=<-' http://sprunge.us"

# Special aliases
if echo "$HOSTNAME" | grep -q 'niklaas.eu'
then
    alias cs="sudo csync2 -N $(hostname -s).klaas"
fi

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

uname | grep -i linux >/dev/null
if [ $? -eq 0 ]
then
    alias remwn="rem -c+ -m $(date  +%d\ %b\ %Y --date='next week')"
    alias remmn="rem -c -m $(date  +%b\ %Y --date='next month')"
    alias remtm="rem -g -q $(date  +%d\ %b\ %Y --date='tomorrow')"
    alias remtd="rem -g -q"
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
fi
