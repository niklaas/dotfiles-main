# General {{{1

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

export SHELL=$(command -v zsh)
export HOSTNAME=$(hostname)
export GPG_TTY=$(tty)

# EDITOR {{{1

# While I do have the *feeling* that neovim does offer some advantages over
# regular vim, I figured that I should stick to traditional vim in the
# meantime. The main reason for this is that neovim does not support signing
# commits an the command line.

if [ -f ~/.local/bin/nvim -o -L ~/.local/bin/nvim ]
then
    NVIM=~/.local/bin/nvim
else
    NVIM=nvim
fi
alias nvim="${NVIM}"

export EDITOR=vim

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
