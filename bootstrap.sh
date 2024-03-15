#!/bin/bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
DOTFILES_DIR="$ROOT_DIR/dotfiles"

function _link() {
    # Check if the file already exists and is not a symbolic link
    if [[ -f "$2" && ! -L "$2" ]]
    then
        echo "File '$2' already exists, backing up as '$2.backup'"
        mv "$2" "$2.backup"
    elif [[ -L "$2" ]]
    then
        echo "File '$2' already exists but is a symbolic link, replacing..."
    fi
        
    ln -s -f "$1" "$2"
    echo "Creating a symbolic link to '$1' at '$2'"
}

function symlink_dotfiles() {
    local stow_ignored=(
        "iterm2"
    )

    echo "Setting up symlinks for all dotfiles with GNU Stow..."

    for dir in "$DOTFILES_DIR"/*/
    do
        local pkg=$(basename "$dir")

        # If pkg is in the set of ignored stow packages, skip it
        if [[ " ${stow_ignored[@]} " =~ " $pkg " ]]
        then
            echo "Skipping creating symlinks for ignored package '$pkg'"
            continue
        fi

        echo "Creating symlinks for package '$pkg'"
        stow --target="$HOME" --dir="$DOTFILES_DIR" -R "$pkg"
    done
}

function install_stow() {
    brew install stow
}

function setup_ssh_keypair() {
    echo "Generating a new ssh keypair..."

    local ssh_file="$HOME/.ssh/id_ed25519"
    if [ ! -f "$ssh_file" ]
    then
        ssh-keygen -t ed25519 -C "`hostname`" -f "$ssh_file" -P ""
        echo "Generated a new ssh keypair at '$ssh_file'"
    else
        echo "File '$ssh_file' exists already, skipping running ssh-keygen"
    fi
}

function install_homebrew() {
    echo "Installing homebrew..."

    if ! command -v brew &> /dev/null
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "Homebrew installation complete"
    else
        echo "Homebrew already installed, skipping"
    fi
}

function install_homebrew_packages() {
    echo "Installing base homebrew packages..."

    brew install git
    brew install go
    brew install jq
    brew install sqlite
    brew install youtube-dl
    brew install tmux
    brew install awscli
    brew install hledger
    brew install vegeta
    brew install ffmpeg
    brew install fish
    brew install fisher
    brew install tailwindcss
    brew install starship

    brew install --cask keepassxc
    brew install --cask alfred
    brew install --cask iterm2
    brew install --cask visual-studio-code
    brew install --cask sublime-merge
    brew install --cask sublime-text
    brew install --cask rectangle
    brew install --cask scroll-reverser
    brew install --cask balenaetcher
    # brew install --cask tailscale
    brew install --cask logseq
    brew install --cask brave-browser
    brew install --cask docker
    brew install --cask powershell
}

function install_work_homebrew_packages() {
    echo "Installing StatMuse specific homebrew packages..."

    brew install --cask signal
    brew install --cask postman
    brew install --cask rider
    brew install --cask mattermost
    brew install --cask azure-data-studio
    brew install --cask dotnet
    
    brew install node
}

function setup_git() {
    echo "Setting up git..."
    
    if [ ! -f "$HOME/.gitconfig" ]
    then
        cp "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
        echo "Copied .gitconfig"

        echo "Post installation step: git config --global user.name \"First Last\""
        echo "Post installation step: git config --global user.email \"email@domain.com\""
    else
        echo "Config .gitconfig already exists, skipping"
    fi
}

function setup_iterm2() {
    echo "Setting up iterm2..."

    # Ensure the iTerm2 preferences directory exists
    mkdir -p ~/Library/Preferences

    # Direct iTerm2 to load the preferences from your dotfiles location.
    # This command sets the custom preference location and enables preference loading from this location.
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
}

function setup_fish() {
    # Add Fish shell to the list of acceptable shells
    # Check if Fish is already in /etc/shells to avoid duplicating it
    if ! grep -q "$(which fish)" /etc/shells; then
        echo "$(which fish)" | sudo tee -a /etc/shells
        echo "Fish shell added to /etc/shells."
    fi

    local current_shell=$(dscl . -read /Users/$(whoami) UserShell | awk '{print $2}')
    local fish_path=$(which fish)

    # Check if Fish is already the default shell
    if [ "$current_shell" = "$fish_path" ]; then
        echo "Fish is already the default shell."
    else
        # Change the default shell to Fish
        echo "Setting Fish as the default shell."
        chsh -s "$fish_path" $(whoami)
    fi

    echo "Installing fish plugins via fisher..."
    fish -c "fisher install IlanCosman/tide@v6"
    fish -c "fisher install jethrokuan/z"
}

function setup_zsh() {
    local zsh_custom_dir="$HOME/.oh-my-zsh/custom"

    echo "Installing oh-my-zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]
    then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo "Installed oh-my-zsh"
    else
        echo "Oh-my-zsh already installed, skipping"
    fi

    echo "Installing powerlevel10k"
    if [ ! -d "$zsh_custom_dir/themes/powerlevel10k" ]
    then
        git clone https://github.com/romkatv/powerlevel10k.git "$zsh_custom_dir/themes/powerlevel10k"
        echo "Cloned powerlevel10k"
    else
        echo "Powerlevel10k is already cloned, skipping"
    fi

    # https://github.com/zsh-users/zsh-autosuggestions/tree/master
    echo "Installing autosuggestions"
    if [ ! -d "$zsh_custom_dir/plugins/zsh-autosuggestions" ]
    then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom_dir/plugins/zsh-autosuggestions"
        echo "Cloned autosuggestions"
    else
        echo "Autosuggestions is already cloned, skipping"
    fi
}

setup_ssh_keypair
install_homebrew
install_stow
symlink_dotfiles

install_homebrew_packages
# install_work_homebrew_packages
setup_git
setup_fish
setup_iterm2
