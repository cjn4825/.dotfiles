#!/usr/bin/env bash

set -e

DOTFILES="$HOME/.dotfiles"

export BREW_HOME="$HOME/.linuxbrew"

# creates .config if not already
if [ ! -d $HOME/.config ]; then
    echo "Creating .config dir..."
    mkdir -p $HOME/.config
fi

# creates .bashrc.d if not already
if [ ! -d $HOME/.bashrc.d ]; then
    echo "Creating .bashrc.d dir..."
    mkdir -p $HOME/.bashrc.d
fi

# creates .local/bin if not already
if [ ! -d $HOME/.local/bin ]; then
    echo "Creating .local/bin dir..."
    mkdir -p $HOME/.local/bin
fi

# creates homebrew home dir if not already
if [ ! -d $BREW_HOME/bin ]; then
    echo "Creating .linuxbrew/bin dir..."
    mkdir -p "$BREW_HOME/bin"
fi

echo "Appending source spript to .bashrc..."

# add .bashrc.d to be sourced by .bashrc
read -r -d '' SCRIPT << 'EOF'

# --- start of dotfiles config link ---
for file in "$HOME/.bashrc.d"/*; do
    [ -r "$file" ] && . "$file"
done
unset file
# --- end of dotfile config link ---

EOF

echo "Linking dotfiles to host..."

# append the script to .bashrc
echo "$SCRIPT" >> "$HOME/.bashrc"

slink() {
    local dotLocation="$DOTFILES/$1"
    local confLocation="$HOME/$2"

    ln -sf "$dotLocation" "$confLocation"
}

# Links files downloaded from github to user environment config locations
slink "bash/.bashrc.d" ".bashrc.d"
slink "nvim" ".config/nvim"
slink "tmux/.tmux.conf" ".tmux.conf"

echo "Dotfiles linked to config dirs"

# download brew if not already for user-space package management
if [ ! command -v brew &>/dev/null ]; then
    echo "Installing Homebrew..."
    git clone https://github.com/Homebrew/brew "$BREW_HOME/Homebrew"
    ln -sfn "$BREW_HOME/Homebrew/bin/brew" "$BREW_HOME/bin/brew"
fi

# adds homebrew to the current terminal session to allow package installs below
eval "$($BREW_HOME/bin/brew shellenv)"

echo "Downloading packages via Homebrew..."

# removed man pages?

packages = (
    neovim
    curl
    tmux
    wget
    unzip
    tar
    gzip
    gtar
    xz
    make
    gcc
    shellcheck
    luarocks
    python3
    python3-pip
    util-linux
    ca-certificates
    nodejs
    ripgrep
    fd-find
    man
    man-pages
    )

for package in "${packages[@]}"; do
    echo "Installing package: $package"
    brew install $package
done

# luarocks install jsregexp? or homebrew?

echo "Packages installed"
echo "Bootstrapping finished"
