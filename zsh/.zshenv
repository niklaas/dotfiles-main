# PATH
typeset -U path
path=(~/.local/bin ~/go/bin ~/n/bin ~/.cargo/bin /snap/bin /opt/local/bin /opt/local/libexec/gnubin $path)
typeset -U fpath
fpath=(~/.local/share/zsh/functions/Completion $fpath)

# Environment variables {{{2

# Locale specific
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_COLLATE=C

# E.g. to use the numbering of calendar weeks that I am used to
export LC_TIME=de_DE.UTF-8
export LC_MEASUREMENT=de_DE.UTF-8
export LC_MONETARY=de_DE.UTF-8

export SHELL=$(command -v zsh)
export HOSTNAME=$(hostname)
export GPG_TTY=$(tty)

# EDITOR {{{1

if [ -f ~/.local/bin/nvim -o -L ~/.local/bin/nvim ]
then
    NVIM=~/.local/bin/nvim
else
    NVIM=nvim
fi
alias nvim="${NVIM}"

if [ "${NVIM}" != "" ]; then
    alias vimdiff=nvim\ -d
    export EDITOR="${NVIM}"
fi

# The variable is used by various git aliases to provide an intuitive interface
# for doing code reviews on the command line. This is heavily inspired by
# https://blog.jez.io/cli-code-review/.
export REVIEW_BASE=master

# Go {{{1
if test -d /usr/local/go/bin
then
    # Looks like golang was installed from upstream directly.
    path=(/usr/local/go/bin $path)
fi
export GOPATH=$HOME/go

# Texlive {{{1
TEXLIVE_DIR=~/.local/texlive/2018
if [ -d $TEXLIVE_DIR ]
then
    path=($TEXLIVE_DIR/bin/x86_64-linux $path)
fi

# FZF {{{1
if command -v fd >/dev/null 2>&1
then
    export FZF_DEFAULT_COMMAND="fd -H -E .git -E .svn --type f"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Others {{{1
export N_PREFIX=$HOME/n
export ANSIBLE_NOCOWS=1
export MOSH_TITLE_NOPREFIX="YES"
export PARINIT="rTbgqR B=.,?_A_a Q=_s>|"

# vim:set foldmethod=marker:
