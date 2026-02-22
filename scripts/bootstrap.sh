#!/usr/bin/env bash

### this script is ONLY for Bootstrapping dev container environments
### that are using a standard devcontainer.json file and with some
### tool like devpod

set -e

DOTFILES="$HOME/dotfiles"
USERBIN="$HOME/.local/bin"
MISEBIN="$USERBIN/mise"

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

# download mise if not already on the system
if [ ! -f "$MISEBIN" ]; then
    curl -Lo "$MISEBIN" "https://mise.jdx.dev/mise-latest-linux-x64" 2>&1
    chmod +x "$MISEBIN"
fi

ACTIVATE="
#--- activate mise to allow its tools to be in PATH

eval \"$(\$HOME/.local/bin/mise activate bash)\"

#--- end of mise activation
"

# if mise isn't activated yet then add to .bashrc
# uses made up code to determine it
if ! grep -q "MISE:146325" "$HOME/.bashrc"; then
    echo "$ACTIVATE" >> "$HOME/.bashrc"
fi

# sets specific versions to use
NEOVIM_VERSION="0.11.6"
TMUX_VERSION="3.6a"
RIPGREP_VERSION="15.1.0"
FD_VERSION="10.3.0"
FZF_VERSION="0.67.0"
GH_VERSION="2.86.0"

# installs tooling with mise in path dir
$MISEBIN use -g neovim@$NEOVIM_VERSION
$MISEBIN use -g tmux@$TMUX_VERSION
$MISEBIN use -g ripgrep@$RIPGREP_VERSION
$MISEBIN use -g fd@$FD_VERSION
$MISEBIN use -g fzf@$FZF_VERSION
$MISEBIN use -g gh@$GH_VERSION

# add .bashrc.d to be sourced by .bashrc and tmux logic
SCRIPT="
# --- start of dotfiles config link ---
if [ -d \"\$HOME/.bashrc.d\" ]; then
    for file in \"\$HOME/.bashrc.d/\"*; do
        [ -r \"\$file\" ] && . \"\$file\"
    done
fi
unset file

# only run in interactive shells
if [ -n \"\$PS1\" ]; then
    # check if we are already in tmux session
    if [ -z \"\$TMUX\" ] && command -v tmux >/dev/null 2>&1; then

        # wait a little for DevPod to finish its 'inject' scripts
        sleep 0.5

        # attempt to attach or create session '0'
        exec tmux a -t 0 >/dev/null || exec tmux new-session -s 0

    fi
fi

# --- end of dotfile config link ---
"

# append the script to .bashrc
echo "$SCRIPT" >> "$HOME/.bashrc"

echo "Bootstrapping finished"
