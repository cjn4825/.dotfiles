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

# install neovim with appimage for fastest download speed
echo "Installing neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 $HOME/.local/nvim-dist
ln -sfn $HOME/.local/nvim-dist/bin/nvim $HOME/.local/bin/nvim
rm nvim-linux-x86_64.tar.gz

# ------------------------------------------working-----------------------------------------------

# install tmux via community static binary
curl -fLo "tmux.tar.gz" https://github.com/tmux/tmux-builds/releases/download/v3.6a/tmux-3.6a-linux-x86_64.tar.gz
tar -xzf tmux.tar.gz
mkdir -p "$HOME/.local/tmux-dist"
mv tmux-3.6a-linux-x86_64/* "$HOME/.local/tmux-dist/"
ln -sfn "$HOME/.local/tmux-dist/tmux" "$HOME/.local/bin/tmux"
chmod +x "$HOME/.local/bin/tmux"
rm -rf tmux.tar.gz tmux-3.6a-linux-x86_64

# install ripgrep dependency
echo "Installing ripgrep..."
curl -Lo rg.tar.gz https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-x86_64-unknown-linux-musl.tar.gz
tar -xzf rg.tar.gz
mv ripgrep-*/rg "$HOME/.local/bin/"
rm -rf ripgrep-* rg.tar.gz
chmod +x "$HOME/.local/bin/rg"

# install fd dependency
echo "Installing fd..."
curl -Lo fd.tar.gz https://github.com/sharkdp/fd/releases/latest/download/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz
tar -xzf fd.tar.gz
# Use a wildcard here too
mv fd-*/fd "$HOME/.local/bin/"
rm -rf fd-* fd.tar.gz
chmod +x "$HOME/.local/bin/fd"

# install tree-sitter cli dependency
echo "Installing treesitter-cli..."
curl -fLo "$HOME/.local/bin/tree-sitter.gz" https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz

# if already unzipped
if file "$HOME/.local/bin/tree-sitter.gz" | grep -q "gzip"; then
    gunzip -f "$HOME/.local/bin/tree-sitter.gz"
else
    mv "$HOME/.local/bin/tree-sitter.gz" "$HOME/.local/bin/tree-sitter"
fi
chmod +x "$HOME/.local/bin/tree-sitter"

echo "Bootstrapping finished"
