export ZSH="$HOME/.oh-my-zsh"
export TERM="wezterm"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

ZSH_THEME="simple-agnoster"
ENABLE_CORRECTION="true"
ZSH_CUSTOM=~/.config/zsh
plugins=(git)

if [[ $+commands[tmux] == "1" ]]; then
  # Automatically run tmux every time zsh is loaded
  : ${TMUX_AUTOSTART:=true}
  # Exit terminal when tmux session exits
  : ${TMUX_AUTOQUIT:=false}

  # Run the below if enabled and not already in tmux, vim, etc.
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" && -z "$VIM" ]]; then
    tmux new-session -A # -s home

    if [[ "$TMUX_AUTOQUIT" == "true" ]]; then
      exit
    fi
  fi
fi

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

source ~/.config/pyenv/bin/activate
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/opt/nvm/nvm.sh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias ccusage="npx ccusage@latest"
alias yst="yadm status"
alias yaa="yadm add ."
