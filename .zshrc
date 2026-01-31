# ============================================================================
# Homebrew (must be early for tools installed via brew)
# ============================================================================
eval "$(/opt/homebrew/bin/brew shellenv)"

# ============================================================================
# Options
# ============================================================================
setopt autocd
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# ============================================================================
# Zinit Setup
# ============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# # ============================================================================
# # Plugins (optimized loading with turbo mode)
# # ============================================================================
# Load compinit early for plugins that need compdef
autoload -Uz compinit && compinit

# # Load immediately (required for prompt)
zinit light-mode for \
    OMZL::git.zsh \
    OMZP::git \
    OMZP::gh \
    OMZP::docker

# Load with turbo mode (after prompt) for faster startup
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

# History substring search (load immediately for keybindings)
zinit ice depth=1; zinit light zsh-users/zsh-history-substring-search

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zinit cdreplay -q

# ============================================================================
# Keybindings
# ============================================================================
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ============================================================================
# Completion Styling
# ============================================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ============================================================================
# Command Checks & Tool Initialization
# ============================================================================
# Check git first (required)
if [[ $+commands[git] == "0" ]]; then
  print "zsh: git command not found. Install git to load zsh correctly." >&2
  return 1
fi

# Editor
if [[ $+commands[nvim] == "1" ]]; then
  export EDITOR='nvim'
  export VISUAL='nvim'
  alias vim="nvim"
  alias v=nvim
  alias vi=nvim
else
  export EDITOR='vim'
  export VISUAL='vim'
  alias v=vim
fi

# Better ls
if [[ $+commands[lsd] == "1" ]]; then
  alias ls="lsd --group-dirs=first"
  alias l="ls -1"
  alias ll="l -l"
  alias la="l -a"
  alias lla="ll -a"
  alias lt="l --tree -I .git -I node_modules"
elif [[ $+commands[eza] == "1" ]]; then
  alias ls="eza --group-directories-first"
  alias l="ls -1"
  alias ll="l -l"
  alias la="l -a"
  alias lla="ll -a"
  alias lt="eza --tree --git-ignore --ignore-glob='node_modules|.git'"
else
  alias ls="ls -G"
  alias l="ls"
  alias ll="ls -lh"
  alias la="ls -a"
  alias lla="ll -a"
fi

if [[ $+commands[rg] == "1" ]]; then
  alias grep=rg
else
  alias grep="grep --color=auto --exclude-dir={.git,.vscode,node_modules}"
fi

[[ $+commands[zoxide] == "1" ]] && eval "$(zoxide init zsh)"
[[ $+commands[mise] == "1" ]] && eval "$(mise activate zsh)"
[[ $+commands[fzf] == "1" ]] && eval "$(fzf --zsh)"
[[ $+commands[op] == "1" ]] && eval "$(op completion zsh)"

# ============================================================================
# Prompt
# ============================================================================
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/catppuccin.json)"
fi

# ============================================================================
# Tmux Autostart
# ============================================================================
if [[ $+commands[tmux] == "1" ]]; then
  : ${TMUX_AUTOSTART:=true}
  : ${TMUX_AUTOQUIT:=false}
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" && -z "$VIM" ]]; then
    tmux new-session -A -s home 2>/dev/null
    [[ "$TMUX_AUTOQUIT" == "true" ]] && exit
  fi
fi

# ============================================================================
# User Config
# ============================================================================
[[ -f "${HOME}/.zshrc.user.zsh" ]] && source "${HOME}/.zshrc.user.zsh"

# pnpm
export PNPM_HOME="/Users/rolandolah/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Mole shell completion
if output="$(mole completion zsh 2>/dev/null)"; then eval "$output"; fi


# opencode
export PATH=/Users/rolandwallner/.opencode/bin:$PATH
