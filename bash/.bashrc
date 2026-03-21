#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export FILE_MANAGER=thunar
export XDG_FILE_MANAGER=thunar

export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias spacman='sudo pacman'
#alias systemctl='sudo systemctl'
alias svi='sudo nvim'
alias vi='nvim'

alias hyprconfig='cd ~/.config/hypr && nvim .'

# Alias de pacman
alias pacup='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacsearch='pacman -Ss'
alias pacinfo='pacman -Qi'
alias pacclean='sudo pacman -Rns $(pacman -Qdtq)'
alias paclist='pacman -Qe'

PS1="\n\[\e[1;36m\][\$(pwd)]\[\e[0m\]\n\[\e[1;32m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]\$ "

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/rzzz/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.local/bin:$PATH"

# Load system locale configuration
if [ -f /etc/locale.conf ]; then
  source /etc/locale.conf
fi

if [[ "$TERM" == "xterm-kitty" ]] && [[ -z "$FASTFETCH_RUN" ]]; then
  export FASTFETCH_RUN=1
  fastfetch
fi
