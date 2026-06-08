#
# ~/.bashrc
#

[[ $- != *i* ]] && return

# ────────────────────────────────────────────────
# MACHINE
# ────────────────────────────────────────────────
machine="$(uname -n)"

# ────────────────────────────────────────────────
# HYPRLAND
# ────────────────────────────────────────────────
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  if [ "${HOSTNAME}" = "${machine}" ]; then
    exec start-hyprland
  fi
fi

# ────────────────────────────────────────────────
# EXPORTS
# ────────────────────────────────────────────────

export FILE_MANAGER=thunar
export XDG_FILE_MANAGER=thunar
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland

export PATH="$HOME/.local/bin:$PATH"

# Load system locale
if [ -f /etc/locale.conf ]; then
  source /etc/locale.conf
fi

# ────────────────────────────────────────────────
# ALIASES — general
# ────────────────────────────────────────────────

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias spacman='sudo pacman'
alias svi='sudo nvim'
alias vi='nvim'
alias hyprconfig='cd ~/.config/hypr && nvim .'

# ────────────────────────────────────────────────
# ALIASES — pacman
# ────────────────────────────────────────────────

alias pacup='sudo pacman -Sy'
alias pacupgr='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacsearch='pacman -Ss'
alias pacinfo='pacman -Qi'
alias pacclean='sudo pacman -Rns $(pacman -Qdtq)'
alias paclist='pacman -Qe'

# ────────────────────────────────────────────────
# ALIASES — yay (AUR)
# ────────────────────────────────────────────────

alias yayin='yay -S'
alias yayup='yay -Sua'
alias yayupgr='yay -Syu'
alias yaysearch='yay -Ss'
alias yayinfo='yay -Si'
alias yaylist='yay -Qm'
alias yayclean='yay -Yc'
alias yayorphans='yay -Rns $(yay -Qdtq)'
alias yaypurge='yay -Scc'
alias yayconf='yay -Pg'
alias yaystats='yay -Ps'

# ────────────────────────────────────────────────
# PROMPT
# ────────────────────────────────────────────────

PS1="\n\[\e[1;36m\][\$(pwd)]\[\e[0m\]\n\[\e[1;32m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]\$ "

# ────────────────────────────────────────────────
# FASTFETCH — mostrar al abrir kitty
# ────────────────────────────────────────────────

if [[ "$TERM" == "xterm-kitty" ]] && [[ -z "$FASTFETCH_RUN" ]]; then
  export FASTFETCH_RUN=1
  fastfetch
fi

# ════════════════════════════════════════════════
# MSI ONLY — eliminar o comentar en el Legion
# ════════════════════════════════════════════════

export LIBVA_DRIVER_NAME=radeonsi

# LM Studio
export PATH="$PATH:/home/rzzz/.lmstudio/bin"

# ROCm (AMD GPU compute)
export PATH=$PATH:/opt/rocm/bin

# Ollama (CUDA/ROCm)
alias ollama-stop='pkill -f "ollama serve" && echo "Ollama detenido"'
alias ollama-start='OLLAMA_LLM_LIBRARY="cuda_v13" ollama serve > /dev/null 2>&1 & sleep 2 && echo "Ollama listo"'
alias chat-code='OLLAMA_LLM_LIBRARY="cuda_v13" ollama run qwen-coder'
alias chat='OLLAMA_LLM_LIBRARY="cuda_v13" ollama run qwen2.5:7b'

# llama.cpp (build ROCm)
alias llama-cli="~/.cache/yay/llama-cpp-rocm-git/src/llama.cpp/build/bin/llama-cli"
alias llama-server="~/.cache/yay/llama-cpp-rocm-git/src/llama.cpp/build/bin/llama-server"
