typeset -U path
path=(~/bin $path)

autoload -U zmv         # loads zmv for bulk renaming

export LC_COLLATE=C
export EDITOR=vim
export HOSTNAME=$(hostname)
export MOSH_TITLE_NOPREFIX="YES"
export PARINIT="rTbgqR B=.,?_A_a Q=_s>|"

alias a="aptitude"
alias aria2cd="aria2c --enable-rpc --rpc-listen-all"
alias ejal="ezjail-admin list"
alias ejall="ezjail-admin list | grep -e '^ZR' -e '^ZSN' -e '^ZS' | awk '{ print \$3\"\\t\\t\"\$1\"\\t\"\$4 }' | sort -u"
alias gsp="git submodule foreach git pull origin master"
alias kccfct="keychain -q --eval tank.financecomm.com-root"
alias kcgpg="keychain -q --eval 1C62D5F3"
alias mcssh="cssh -C .clusterssh/config_mosh"
alias mpvdf="mpv --playlist=http://www.dradio.de/streaming/dlf_hq_ogg.m3u"
alias mpvdk="mpv --playlist=http://www.dradio.de/streaming/dkultur_hq_ogg.m3u"
alias mpvdw="mpv --playlist=http://www.dradio.de/streaming/dradiowissen_hq_ogg.m3u"
alias ra="rsync -a"
alias remm="rem -c -m"
alias remw="rem -c+ -m"
alias rs="rsync"
alias rsync.net="ssh 16264@ch-s010.rsync.net"
alias tree="tree --charset=ascii"
alias v="vim --servername vim"
alias vv="vim -MR -c 'file [stdin]' -"

if echo "$HOSTNAME" | grep -q 'niklaas.eu'
then
    alias cs="sudo csync2 -N $(hostname -s).klaas"
fi

alias sudo="my_sudo " # makes aliases pass from local user to root

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

alias S="curl -F 'sprunge=<-' http://sprunge.us"

if [ -f "/usr/local/bin/lesspipe.sh" ]
then
    LESSOPEN="|/usr/local/bin/lesspipe.sh %s"; export LESSOPEN
fi

jails=/usr/local/jails
pdrdir=/usr/local/etc/poudriere.d
letc=/usr/local/etc

uname | grep -i linux >/dev/null
if [ $? -eq 0 ]
then
    alias remwn="rem -c+ -m $(date  +%d\ %b\ %Y --date='next week')"
    alias remmn="rem -c -m $(date  +%b\ %Y --date='next month')"
    alias remtm="rem -g -q $(date  +%d\ %b\ %Y --date='tomorrow')"
    alias remtd="rem -g -q"
fi

command -v keychain >/dev/null 2>&1 && eval $(keychain -q --eval id_rsa)

function pdfpextr()
{
    # this function uses 3 arguments:
    #     $1 is the first page of the range to extract
    #     $2 is the last page of the range to extract
    #     $3 is the input file
    #     output file will be named "inputfile_pXX-pYY.pdf"
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
       -dFirstPage=${1} \
       -dLastPage=${2} \
       -sOutputFile=${3%.pdf}_p${1}-p${2}.pdf \
       ${3}
}

function lprdbl()
{
    lpr -P PDF \
        -o fitplot \
        -o number-up=2 \
        "$@"
}
