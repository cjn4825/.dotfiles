#!/usr/bin/env bash

set -e

DOTFILES="$HOME/.dotfiles"

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

echo "Appending source spript to .bashrc..."

# add .bashrc.d to be sourced by .bashrc
read -r -d '' SCRIPT << 'EOF'

# --- start of dotfiles config link ---
for file in "$HOME/.bashrc.d/*"; do
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

echo "Dotfiles linked to host!"
