#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"

export BREW_HOME="$HOME/.linuxbrew"

# creates .config if not already
if [ ! -d $HOME/.config ]; then
    echo "Creating .config dir..."
    mkdir -p $HOME/.config
fi

# creates .local/bin for binaries
if [ ! -d $HOME/.local/bin ]; then
    echo "Creating .local/bin dir..."
    mkdir -p $HOME/.local/bin
fi

# creates homebrew home dir if not already
if [ ! -d $BREW_HOME/bin ]; then
    echo "Creating .linuxbrew/bin dir..."
    mkdir -p "$BREW_HOME/bin"
fi

slink() {
    local dotLocation="$DOTFILES/$1"
    local confLocation="$HOME/$2"

    echo "linking $dotLocation to $confLocation"
    ln -sfn "$dotLocation" "$confLocation"
}

echo "Linking dotfiles to host..."

# Links files downloaded from github to user environment config locations
slink "bash/.bashrc.d" ".bashrc.d"
slink "nvim" ".config/nvim"
slink "tmux/.tmux.conf" ".tmux.conf"

echo "Dotfiles linked to config dirs"
echo "Appending source spript to .bashrc..."

# add .bashrc.d to be sourced by .bashrc
SCRIPT='
# --- start of dotfiles config link ---
for file in "$HOME/.bashrc.d"/*; do
    [ -r "$file" ] && . "$file"
done
unset file
# --- end of dotfile config link ---
'
# append the script to .bashrc
echo "$SCRIPT" >> "$HOME/.bashrc"

# download brew if not already for user-space package management
# if ! command -v brew &>/dev/null; then
#     echo "Installing Homebrew..."
#     git clone https://github.com/Homebrew/brew "$BREW_HOME/Homebrew"
#     ln -sfn "$BREW_HOME/Homebrew/bin/brew" "$BREW_HOME/bin/brew"
# fi

# adds homebrew to the current terminal session to allow package installs below
# eval "$($BREW_HOME/bin/brew shellenv)"

# echo "Downloading packages via Homebrew..."

# removed man pages?

# packages=(
#     tmux
#     shellcheck
#     luarocks
#     ripgrep
#     fd
#     )

# for package in "${packages[@]}"; do
#     echo "Installing package: $package"
#     brew install $package
# done

# luarocks install jsregexp dependency for neovim
# luarocks install jsregexp

# install neovim with appimage for fastest download speed
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 $HOME/.local/nvim-dist
ln -sfn $HOME/.local/nvim-dist/bin/nvim $HOME/.local/bin/nvim

echo "Packages installed"
echo "Bootstrapping finished"
