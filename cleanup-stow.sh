#!/bin/bash
set -euo pipefail

function _delete_link() {
    if [[ -L "$1" ]]
    then
        echo "Deleting symbolic link '$1'"
        rm "$1"
    elif [[ -f "$1" ]]
    then
        echo "Deleting file '$1'"
        rm "$1"
    fi
}

_delete_link "$HOME/.vimrc"
_delete_link "$HOME/.tmux.conf"
_delete_link "$HOME/.config/fish/config.fish"
_delete_link "$HOME/.config/fish/fish_plugins"
_delete_link "$HOME/.config/fish/functions/git-prune.fish"
_delete_link "$HOME/.p10k.zsh"
_delete_link "$HOME/.zshrc"
_delete_link "$HOME/.gitconfig_xplat"
_delete_link "$HOME/.gitconfig_plat"