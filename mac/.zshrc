export TERM=xterm-256color

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

autoload -U colors && colors
PS1="%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%# "

alias l='ls -f'
alias ll='ls -l'
alias la='ls -Al'

# Open in Nova
alias -s {cs,js,html}=nova

# Git aliases
alias push='eval "$(ssh-agent -s)"; ssh-add ~/.ssh/github; git push'
alias pull='eval "$(ssh-agent -s)"; ssh-add ~/.ssh/github; git fetch origin; git merge origin/main'

# path to php8.0
export PATH="/usr/local/opt/php@8.0/bin:$PATH"
