#!/bin/bash

set -e

ln -sf /mnt/c/dev/git/millerhederi/machine-bootstrap/wsl/tmux/.tmux.conf ~/.tmux.conf

ln -sf /mnt/c/dev/git/millerhederi/machine-bootstrap/dotfiles/Git/.gitconfig_xplat ~/.gitconfig_xplat
ln -sf /mnt/c/dev/git/millerhederi/machine-bootstrap/dotfiles/Git/.gitconfig_linux ~/.gitconfig_plat
cp -f /mnt/c/dev/git/millerhederi/machine-bootstrap/dotfiles/Git/.gitconfig ~/.gitconfig

sudo apt-get update
sudo apt-get upgrade -y
