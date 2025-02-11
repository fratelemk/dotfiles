# Aliases
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# Prompt
PS1=$'\n'"%F{green} %* %F{240}%3~ %F{white}"$'\n'"$ "

# History
HISTSIZE=10000
SAVEHIST=10000

# Completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Navigation
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

source /Users/mihaiflorescu/.local/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/mihaiflorescu/.local/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
