#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

# Links files downloaded from github to user environment
ln -sf "$DOTFILES/bash/.bashrc.d/prompt.sh" "$HOME/.bashrc.d/prompt.sh"
ln -sf "$DOTFILES/bash/.bashrc.d/tmux_colors.sh" "$HOME/.bashrc.d/tmux_colors.sh"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "dotfiles linked to host"
