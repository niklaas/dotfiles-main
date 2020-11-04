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

# The variable is used by various git aliases to provide an intuitive interface
# for doing code reviews on the command line. This is heavily inspired by
# https://blog.jez.io/cli-code-review/.
export REVIEW_BASE=master

# Go {{{1
export GOPATH=$HOME/go

# Others {{{1
export N_PREFIX=$HOME/n
export ANSIBLE_NOCOWS=1
export MOSH_TITLE_NOPREFIX="YES"
export PARINIT="rTbgqR B=.,?_A_a Q=_s>|"

# vim:set foldmethod=marker:
