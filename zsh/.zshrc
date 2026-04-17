# =========================================================
# ZSH CONFIG — OPTIMIZED, CLEAN, FAST
# =========================================================

# ------------------------------
# Powerlevel10k Instant Prompt (KEEP AT TOP)
# ------------------------------
# Must stay near the top for fastest startup
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------
# HISTORY CONFIGURATION
# ------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt AUTO_CD                   # enable directory paths
setopt BANG_HIST                 # ! expansion
setopt EXTENDED_HISTORY          # timestamps in history
setopt INC_APPEND_HISTORY        # write immediately
setopt SHARE_HISTORY             # share across terminals

# deduplication & cleanup
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# ------------------------------
# GENERAL OPTIONS
# ------------------------------
setopt glob_dots                 # include hidden files in globbing
bindkey -e                       # emacs-style keybindings
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# ------------------------------
# COMPLETION SYSTEM (FAST)
# ------------------------------
autoload -Uz compinit

# Use cache to speed up startup
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
compinit -d "$ZSH_COMPDUMP"

# Completion UI tuning
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes

# smart matching (case insensitive + flexible)
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Colors
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Docker tweaks
zstyle ':completion:*:*:docker:*' option-stacking yes

# ------------------------------
# ANTIDOTE (PLUGIN MANAGER)
# ------------------------------
# Load antidote
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh

# Load plugins from ~/.zsh_plugins.txt
antidote load

# ------------------------------
# TOOLS (SAFE + FAST)
# ------------------------------

# zoxide (better cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# fzf (fuzzy finder)
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --no-messages --files --hidden --follow --glob "!.git/*"'
  export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
  source <(fzf --zsh)
fi

# ------------------------------
# ALIASES & LOCAL CONFIG
# ------------------------------
# Load aliases if file exists
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# Machine-specific overrides (optional)
[ -f ~/.zsh_local ] && source ~/.zsh_local

# ------------------------------
# PROMPT (POWERLEVEL10K)
# ------------------------------
# Load config if present
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ------------------------------
# OPTIONAL FEATURES (DISABLED)
# ------------------------------

# Auto-start tmux
# [[ -z "$TMUX" ]] && exec tmux new -As0

# Command correction tool
# eval "$(thefuck --alias)"

# Better LS_COLORS with vivid
# export LS_COLORS="$(vivid generate dracula)"

# =========================================================
# PERFORMANCE NOTES
# =========================================================
# - Keep ~/.zsh_plugins.txt minimal (2–4 plugins max)
# - Prefer tools (rg, fd, zoxide) over plugins
# - Avoid heavy frameworks like oh-my-zsh
# =========================================================
