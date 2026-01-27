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

# install mise for user wide package management with binaries
curl -Lo mise https://mise.jdx.dev/mise-latest-linux-x64
chmod +x mise
mv mise "$HOME/.local/bin"

# function that makes mise link to .local/bin easier
miselink() {
    local miseLocation="$HOME/.local/share/mise/installs/$1"
    local binLocation="$HOME/.local/bin/$2"

    echo "linking $miseLocation to $binLocation"
    ln -sfn "$miseLocation" "$binLocation"
}

MISE="$HOME/.local/bin/mise"

# sets specific versions to use
NEOVIM_VERSION="0.11.6"
TMUX_VERSION="3.6a"
RIPGREP_VERSION="15.1.0"
FD_VERSION="10.3.0"
FZF_VERSION="0.67.0"
GH_VERSION="2.86.0"

# installs tooling with mise
$MISE use neovim@$NEOVIM_VERSION
$MISE use tmux@$TMUX_VERSION
$MISE use ripgrep@$RIPGREP_VERSION
$MISE use fd@$FD_VERSION
$MISE use fzf@$FZF_VERSION
$MISE use gh@$GH_VERSION

# uses miselink to link mise tools to bin
miselink neovim/$NEOVIM_VERSION/bin/nvim nvim
miselink tmux/$TMUX_VERSION/tmux tmux
miselink ripgrep/$RIPGREP_VERSION/ripgrep-$RIPGREP_VERSION-x86_64-unknown-linux-musl/rg rg
miselink fd/$FD_VERSION/fd-v$FD_VERSION-x86_64-unknown-linux-musl/fd fd
miselink fzf/$FZF_VERSION/fzf fzf
miselink gh/$GH_VERSION/gh_$GH_VERSION\_linux_amd64/bin/gh gh

# installs gh-dash for terminal github integration (should check if it already exists first...)
"$HOME/.local/bin/gh" extension install dlvhdr/gh-dash

# move mise.toml to mise dir
mv mise.toml "$HOME/.local/share/mise/"

echo "Bootstrapping finished"
