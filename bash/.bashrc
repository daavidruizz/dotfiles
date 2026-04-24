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
alias pacup='sudo pacman -Sy'
alias pacupgr='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacsearch='pacman -Ss'
alias pacinfo='pacman -Qi'
alias pacclean='sudo pacman -Rns $(pacman -Qdtq)'
alias paclist='pacman -Qe'
#Alias yay AUR
# Instalación y actualización
alias yayin='yay -S'                # Instalar (busca en repos y AUR)
alias yayup='yay -Sua'              # Actualizar SOLO paquetes de la AUR
alias yayupgr='yay -Syu'            # Actualizar TODO (Sistema + AUR)

# Búsqueda e Información
alias yaysearch='yay -Ss'           # Buscar en repos y AUR
alias yayinfo='yay -Si'             # Información detallada del paquete en la red
alias yaylist='yay -Qm'             # Listar solo paquetes instalados desde la AUR

# Limpieza y Mantenimiento
alias yayclean='yay -Yc'            # Limpiar dependencias AUR no deseadas
alias yayorphans='yay -Rns $(yay -Qdtq)' # Eliminar huérfanos (incluyendo AUR)
alias yaypurge='yay -Scc'           # Limpiar TODA la caché (cuidado, borra descargas)

# Extras útiles
alias yayconf='yay -Pg'             # Ver la configuración actual de yay
alias yaystats='yay -Ps'            # Ver estadísticas de paquetes instalados

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

## Ollama
# Ollama
# En ~/.zshrc cambia ollama-start a:
alias ollama-stop='pkill -f "ollama serve" && echo "Ollama detenido"'
alias ollama-start='OLLAMA_LLM_LIBRARY="cuda_v13" ollama serve > /dev/null 2>&1 & sleep 2 && echo "Ollama listo"'
alias chat-code='OLLAMA_LLM_LIBRARY="cuda_v13" ollama run qwen-coder'
alias chat='OLLAMA_LLM_LIBRARY="cuda_v13" ollama run qwen2.5:7b'
