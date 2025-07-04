export ZSH="$HOME/.oh-my-zsh"
export TERM="wezterm"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"

# Activate python local en
source ~/.config/pyenv/bin/activate

ZSH_THEME="simple-agnoster"

# Taken from ohmyzsh
#   @see https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/tmux/tmux.plugin.zsh
#
# Enable tmux
: ${TMUX_ENABLED:=true}
# Automatically attach to a previous session (if it exists)
: ${TMUX_AUTOATTACH:=true}
# Exit terminal when tmux session exits
: ${TMUX_AUTOEXIT:=true}
# Set the default tmux session name
# : ${TMUX_DEFAULT_SESSION_NAME:=default}
if [[ $+commands[tmux] && "$TMUX_ENABLED" == "true" && -z "$TMUX" ]]; then
  if [[ -n "$TMUX_DEFAULT_SESSION_NAME" ]]; then
    [[ "$TMUX_AUTOATTACH" == "true" ]] && tmux attach -t $TMUX_DEFAULT_SESSION_NAME
  else
    [[ "$TMUX_AUTOATTACH" == "true" ]] && tmux attach
  fi

  if [[ $? -ne 0 ]]; then
    if [[ -n "$TMUX_DEFAULT_SESSION_NAME" ]]; then
      tmux new-session -s $TMUX_DEFAULT_SESSION_NAME
    else
      tmux new-session
    fi
  fi

  if [[ "$TMUX_AUTOEXIT" == "true" ]]; then
    exit
  fi
fi

ENABLE_CORRECTION="true"

ZSH_CUSTOM=~/.config/zsh

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

source /opt/homebrew/opt/nvm/nvm.sh

 export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

[[ -f /Users/rolandolah/.dart-cli-completion/zsh-config.zsh ]] && . /Users/rolandolah/.dart-cli-completion/zsh-config.zsh || true

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias ccusage="npx ccusage@latest"
alias claude-monitor="uv tool run claude-monitor"

alias yst="yadm status"
alias yaa="yadm add ."

alias cxc-latest="sudo xcode-select -s /Applications/Xcode.app"
alias cxc-14="sudo xcode-select -s /Applications/Xcode_14.3.1.app"
alias open_xcode_14="/Applications/Xcode_14.3.1.app/Contents/MacOS/Xcode"
alias list_ios_booted="xcrun simctl list devices | grep "Booted""
