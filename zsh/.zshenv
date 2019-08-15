# General {{{1

typeset -U path
path=(~/.local/bin ~/go/bin ~/n/bin ~/.cargo/bin /snap/bin $path)
typeset -U fpath
fpath=(~/.local/share/zsh/functions/Completion $fpath)

autoload -U zmv  # zsh's bulk renaming
autoload -U is-at-least
autoload -U compdef
autoload -U zcalc

# Completion {{{1

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

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

export EDITOR="${NVIM}"

# The variable is used by various git aliases to provide an intuitive interface
# for doing code reviews on the command line. This is heavily inspired by
# https://blog.jez.io/cli-code-review/.
export REVIEW_BASE=master

export MANPAGER="$EDITOR -c 'set filetype=man'"

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

# TERMINAL {{{1
if command -v uxterm >/dev/null 2>&1
then
    export TERMINAL="uxterm"
elif command -v xterm >/dev/null 2>&1
then
    export TERMINAL="xterm"
fi

# Others {{{1
export N_PREFIX=$HOME/n
export ANSIBLE_NOCOWS=1
export MOSH_TITLE_NOPREFIX="YES"
export PARINIT="rTbgqR B=.,?_A_a Q=_s>|"

# vim:set foldmethod=marker:
