#!/usr/bin/env bash

# exists if anything fails
set -e

# Links files downloaded from github to user environment by force

DOTFILES="$HOME/.dotfiles"

ln -sf "$DOTFILES/bash/.bashrc.d/prompt.sh" "$HOME/.bashrc.d/prompt.sh"
ln -sf "$DOTFILES/bash/.bashrc.d/tmux_colors.sh" "$HOME/.bashrc.d/tmux_colors.sh"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/tmux/.tmux" "$HOME/.tmux"
ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/fonts/firacode" "$HOME/.local/share/fonts"

echo "Dotfiles linked!"
