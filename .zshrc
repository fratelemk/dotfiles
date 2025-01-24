# Aliases
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# Prompt
export PS1=$'\n'"%F{green} %* %F{240}%3~ %F{white}"$'\n'"$ "

# Enable shell completion
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
autoload -U compinit; compinit

# Blender
export PATH="/Applications/Blender.app/Contents/MacOS:$PATH"
