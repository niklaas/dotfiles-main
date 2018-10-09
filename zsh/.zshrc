# Dynamically load zsh plugins with antibody
if command -v antibody >/dev/null 2>&1
then
    source <(antibody init)
    antibody bundle < ~/.zsh_plugins.txt
else
    echo 'Please install antibody.'
fi

if ! find /usr/share/terminfo -type f -name tmux-256color >/dev/null
then
    echo "terminfo tmux-256color probably not available"
    echo "this will most likely result in misbehaviour"
    echo "install ncurses-term"
fi

HISTFILE=${HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

test -f ${HOME}/.zshrc.local && source ${HOME}/.zshrc.local

# Removes aliases from oh-my-zsh/common-aliases that conflict with `fd`, an
# alternative for `find` written in Rust
type fd | grep alias >/dev/null 2>&1 && unalias fd
type ff | grep alias >/dev/null 2>&1 && unalias ff

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# Enables vim mode
bindkey -v

bindkey '^a' autosuggest-accept
bindkey '^e' autosuggest-execute

bindkey -s '^z' 'fg\n'

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

if ! command -v fzf >/dev/null 2>&1
then
    bindkey '^R' history-incremental-pattern-search-backward
    bindkey '^P' vi-up-line-or-history
    bindkey '^N' vi-down-line-or-history
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
