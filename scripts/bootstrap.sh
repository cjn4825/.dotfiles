#!/usr/bin/env bash

# This script is for bootstrapping environments for neovim use
# Works as a way to package all the tooling I need for
# neovim without needing root access to the system

set -e

# main boolean to check if nothing changed or not
CHANGED=false

# check if not container to set dotfiles dir
if [ ! -f "/.dockerenv" ]; then
    DOTFILES="$HOME/dotfiles"
else
    DOTFILES="$HOME/.dotfiles"
fi

USERBIN="$HOME/.local/bin"
MISEBIN="$USERBIN/mise"

# creates ~/.config if not already there
if [ ! -d "$HOME/.config" ]; then
    CHANGED=true
    echo "Creating .config dir..."
    mkdir -p "$HOME/.config"
fi

# creates ~/.local/bin if not already there
if [ ! -d "$HOME/.local/bin" ]; then
    CHANGED=true
    echo "Creating .local/bin dir..."
    mkdir -p "$HOME/.local/bin"
fi

# creates ~/.bashrc.d if not already there
if [ ! -d "$HOME/.bashrc.d" ]; then
    CHANGED=true
    echo "Creating .bashrc.d dir..."
    mkdir -p "$HOME/.bashrc.d"
fi

# function that makes dotfiles link easier
dotlink() {
    local dotLocation="$DOTFILES/$1"
    local confLocation="$HOME/$2"

    if [ ! -d "$confLocation" ] && [ ! -f "$confLocation" ]; then
        CHANGED=true
        echo "Linking [$dotLocation] to [$confLocation]"
        ln -sfn "$dotLocation" "$confLocation"
    fi
}

# Links files downloaded from github to user environment config locations
dotlink "bash/.bashrc.d/prompt.sh" ".bashrc.d/prompt.sh"
dotlink "nvim" ".config/nvim"
dotlink "tmux/.tmux.conf" ".tmux.conf"

USERPATH="
#--- sets user path to .local/bin
export PATH=\"\$PATH:\$HOME/.local/bin\"
#--- end of setting user path
"

# if user path isn't added already
if ! grep -q "sets user path to" "$HOME/.bashrc"; then
    CHANGED=true
    echo "Adding user path to .bashrc..."
    echo "$USERPATH" >> "$HOME/.bashrc"
fi

# download mise if not already on the system
if [ ! -f "$MISEBIN" ]; then
    CHANGED=true
    echo "Downloading mise via curl..."
    curl -Lo "$MISEBIN" "https://mise.jdx.dev/mise-latest-linux-x64" 2>&1
    chmod +x "$MISEBIN"
fi

MISEPATH="
#--- sets mise tool shims to be in path
export PATH=\$PATH:\"\$HOME/.local/share/mise/shims\"
#--- end of mise shims config
"

# only do anything with mise if the project is inside a container
# and if the env var is not set yet
if [ ! -f "/.dockerenv" ]; then
    if ! grep -q "mise tool shims" "$HOME/.bashrc"; then
        CHANGED=true
        echo "Adding mise tools to PATH"
        echo "$MISEPATH" >> "$HOME/.bashrc"
    fi
fi

checkmise() {
    local name=$1
    local version=$2
    local tool=$name@$version

    if ! mise where "$tool" >/dev/null 2>&1; then
	$MISEBIN use -g "$tool"
	CHANGED=true
    fi
}

# sets specific versions to use
NEOVIM_VERSION="0.11.6"
TMUX_VERSION="3.6a"
RG_VERSION="15.1.0"
FD_VERSION="10.3.0"
FZF_VERSION="0.67.0"
PY_VERSION="3.14.3"
NODE_VERSION="25.6.1"

checkmise "neovim" "$NEOVIM_VERSION"
checkmise "tmux" "$TMUX_VERSION"
checkmise "ripgrep" "$RG_VERSION"
checkmise "fd" "$FD_VERSION"
checkmise "fzf" "$FZF_VERSION"
checkmise "python" "$PY_VERSION"
checkmise "node" "$NODE_VERSION"

SOURCE="
# --- start of dotfiles config link ---
if [ -d \"\$HOME/.bashrc.d\" ]; then
    for file in \"\$HOME/.bashrc.d/\"*; do
        [ -r \"\$file\" ] && . \"\$file\"
    done
fi
unset file
# --- end of dotfile config link ---
"

# check if .bashrc.d isn't mentioned in .bashrc
if ! grep -q "start of dotfiles config link" "$HOME/.bashrc" && ! grep -q ".bashrc.d" "$HOME/.bashrc"; then
    CHANGED=true
    echo "Adding .bashrc.d sourcing to .bashrc..."
    echo "$SOURCE" >> "$HOME/.bashrc"
fi

TMUX="
# --- start of devcontainer tmux config ---
# only run in interactive shells
if [[ \$- == *i* ]]; then

    # check if we are already in tmux session
    if command -v tmux >/dev/null 2>&1 && [ -z \"\$TMUX\" ]; then

        # attach if the session exists otherwise create one
        tmux a -t 0 >/dev/null 2>&1 || tmux new-session -s 0 >/dev/null 2>&1

        exit 0
    fi
fi
# --- end of devcontainer tmux config ---
"

# check if host is a container
if [ -f "/.dockerenv" ] && ! grep -q "start of devcontainer tmux config"; then
    CHANGED=true
    echo "Adding tmux sesssion auto attach to .bashrc..."
    echo "$TMUX" >> "$HOME/.bashrc"
fi

# output different based on CHANGED value
if [ "$CHANGED" = true ]; then
    echo "Bootstrapping finished"
else
    echo "System is already bootstrapped"
fi
