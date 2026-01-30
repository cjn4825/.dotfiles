#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

# creates .config if not already
if [ ! -d "$HOME/.config" ]; then
    echo "Creating .config dir..."
    mkdir -p "$HOME/.config"
fi

# creates .local/bin for binaries
if [ ! -d "$HOME/.local/bin" ]; then
    echo "Creating .local/bin dir..."
    mkdir -p "$HOME/.local/bin"
fi

# function that makes dotfiles link easier
dotlink() {
    local dotLocation="$DOTFILES/$1"
    local confLocation="$HOME/$2"

    echo "linking $dotLocation to $confLocation"
    ln -sfn "$dotLocation" "$confLocation"
}

echo "Linking dotfiles to host..."

# Links files downloaded from github to user environment config locations
dotlink "bash/.bashrc.d" ".bashrc.d"
dotlink "nvim" ".config/nvim"
dotlink "tmux/.tmux.conf" ".tmux.conf"

echo "Dotfiles linked to config dirs"
echo "Appending source spript to .bashrc..."

# add .bashrc.d to be sourced by .bashrc
SCRIPT="
# --- start of dotfiles config link ---
if [ -d \"\$HOME/.bashrc.d\" ]; then
    for file in \"\$HOME/.bashrc.d/\"*; do
        [ -r \"\$file\" ] && . \"\$file\"
    done
fi
unset file
# --- end of dotfile config link ---
"

# append the script to .bashrc
echo "$SCRIPT" >> "$HOME/.bashrc"

# install mise for user wide package management with binaries
# curl -Lo mise --output-dir "$HOME/.local/bin/" "https://mise.jdx.dev/mise-latest-linux-x64"

# gives the user executible permissions for mise
# chmod +x "$HOME/.local/bin/mise"

# uses mise to add its downloaded tools to $PATH
# ACTIVATE="
# # --- activate mise to allow its tools to be in PATH

# eval '$HOME/.local/bin/mise activate bash'

# # --- end of activation
# "

# append activate to .bashrc
# echo "$ACTIVATE" >> "$HOME/.bashrc"

#############ASSUMES THE PROJECT HAS MISE INSTALLED#########

MISE="$HOME/.local/bin/mise"

# sets specific versions to use
NEOVIM_VERSION="0.11.6"
TMUX_VERSION="3.6a"
RIPGREP_VERSION="15.1.0"
FD_VERSION="10.3.0"
FZF_VERSION="0.67.0"
GH_VERSION="2.86.0"

# installs tooling with mise in path dir
$MISE use -g neovim@$NEOVIM_VERSION
$MISE use -g tmux@$TMUX_VERSION
$MISE use -g ripgrep@$RIPGREP_VERSION
$MISE use -g fd@$FD_VERSION
$MISE use -g fzf@$FZF_VERSION
$MISE use -g gh@$GH_VERSION

echo "Bootstrapping finished"
