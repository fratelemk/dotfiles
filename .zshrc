# Aliases
alias ll='ls -GThlp'
alias la='ls -AGp'
alias lla='ls -AGThlp'
alias lsd='ls -Gd */'
alias llsd='ls -lGTd */'

# Functions

mk_venv() {
	if [ -d ".venv" ]; then
		echo "Error: A .venv directory already exists in $(pwd)" >&2
		return 1
	fi

	python3 -m venv .venv
	if [ $? -ne 0 ]; then
		echo "Error: Failed to create virtual environment." >&2
		return 1
	fi

	source .venv/bin/activate

	pip install -U -q pip

	echo "Initialized new virtual environment in $(pwd)/.venv"
}

# Prompt
PS1=$'\n'"%F{green} %* %F{240}%3~ %F{white}"$'\n'"$ "

# History
HISTSIZE=10000
SAVEHIST=10000

# Completion
zstyle ':completion:*' menu select
zmodload zsh/complist
autoload -Uz compinit; compinit

# Navigation
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

source $HOME/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
