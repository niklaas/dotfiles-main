source $HOME/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle autojump
antigen bundle aws
antigen bundle catimg
antigen bundle debian
antigen bundle extract
antigen bundle git
antigen bundle mercurial
antigen bundle sudo
antigen bundle svn
antigen bundle urltools
antigen bundle web-search

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen theme flazz
antigen apply

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# Enables vim mode
bindkey -v

bindkey '^a' autosuggest-accept
bindkey '^e' autosuggest-execute
