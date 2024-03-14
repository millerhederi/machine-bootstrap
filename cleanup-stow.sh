#!/bin/bash
set -euo pipefail

function _delete_link() {
    if [[ -L "$1" ]]
    then
        echo "Deleting symbolic link '$1'"
    fi
        
    rm "$1"
}

_delete_link "$HOME/.vimrc"
_delete_link "$HOME/.tmux.conf"