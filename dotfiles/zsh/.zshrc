# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  zsh-autosuggestions
  git 
  z 
)

source $ZSH/oh-my-zsh.sh

export PATH="~/go/bin:$PATH"

# Enable starship prompt
eval "$(starship init zsh)"