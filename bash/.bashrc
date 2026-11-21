#
# ~/.bashrc — se ejecuta en CADA terminal interactiva
#
# Solo alias, funciones, prompt. Las variables de entorno van en ~/.bash_profile.
#

[[ $- != *i* ]] && return

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
#alias yayup='yay -Sua'
#alias yayupgr='yay -Syu'
alias yaysearch='yay -Ss'
alias yayinfo='yay -Si'
alias yaylist='yay -Qm'
alias yayclean='yay -Yc'
alias yayorphans='yay -Rns $(yay -Qdtq)'
alias yaypurge='yay -Scc'
alias yayconf='yay -Pg'
alias yaystats='yay -Ps'

# Puerta común: corre el auditor y decide según su código de salida.
_yay_audit_gate() {
  aur-audit
  local rc=$?
  if ((rc == 2)); then
    echo "IOC crítico detectado — abortando."
    return 1
  elif ((rc == 1)); then
    read -rp "Cambios sospechosos. ¿Continuar igualmente? [y/N] " ans
    [[ $ans == [yY] ]] || return 1
  fi
}

yayup() { _yay_audit_gate && yay -Sua "$@"; }   # solo AUR
yayupgr() { _yay_audit_gate && yay -Syu "$@"; } # sistema completo

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

# ────────────────────────────────────────────────
# ESPECÍFICO DE LA MÁQUINA — ~/.bashrc_msi / ~/.bashrc_legion
# ────────────────────────────────────────────────

_host="${HOSTNAME,,}"
_host="${_host#arch}"
[[ -f ~/.bashrc_$_host ]] && . ~/.bashrc_$_host
