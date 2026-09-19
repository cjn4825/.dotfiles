#!/usr/bin/env bash

# This script is for bootstrapping environments for neovim use
# Works as a way to package all the tooling I need for
# neovim without needing root access to the system
# as well as any tools pre/post installed when given
# access manually

# Mise tools version changing area
NEOVIM_VERSION="0.12.5"
TMUX_VERSION="3.6b"
RG_VERSION="15.2.0"
FD_VERSION="10.5.0"
FZF_VERSION="0.74.0"
PY_VERSION="3.14.3"
NODE_VERSION="26.8.1"
TS_VERSION="0.27.0"
CLAUDE_VERSION="2.1.261"
GOPASS_VERSION="1.17.2"

# main booleans to check if changes were made
CHANGED=false
GOPASSCHANGE=false

CONTAINER=false
USERBIN="$HOME/.local/bin"
MISEBIN="$USERBIN/mise"

TOOLPATH="
#--- sets user path to .local/bin and adds mise shims
export PATH=\"\$HOME/.local/share/mise/shims:\$HOME/.local/bin:\$PATH\"
#--- end of setting tool path
"

SOURCE="
# --- start of .bashrc.d config link ---
if [ -d \"\$HOME/.bashrc.d\" ]; then
    for file in \"\$HOME/.bashrc.d/\"*; do
        [ -r \"\$file\" ] && . \"\$file\"
    done
fi
unset file
# --- end of .bashrc.d config link ---
"

MISEPATH="
#--- sets mise tool shims to be in path
export PATH=\"\$HOME/.local/share/mise/shims:\$PATH\"
#--- end of mise shims config
"

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

CRED="
# --- start of in Memory Creds config ---
# Helper function in shell startup to safely load secrets into memory
get_secret() {
  local path=\"\$1\"
  command -v gopass >/dev/null 2>&1 && gopass show -o \"\$path\" 2>/dev/null
}

# Export tokens to local process memory dynamically, only if not already set
# (avoids re-decrypting on every bashrc re-source once it's already loaded)
if [ -z \"\$ANTHROPIC_API_KEY\" ]; then
  export ANTHROPIC_API_KEY=\$(get_secret \"api/anthropic/claude-code\")
fi
# --- end of in Memory Creds config ---
"

containerCheck() {

    # bool for checking if in container
    VIRT_TYPE="$(systemd-detect-virt --container 2>/dev/null)"
    if [[ $VIRT_TYPE != "none" ]] && [[ $VIRT_TYPE != "wsl" ]]; then
        CONTAINER=true
    fi

    # check if not container to set dotfiles dir
    if [[ $CONTAINER == true ]]; then
        DOTFILES="$HOME/dotfiles"
    else
        DOTFILES="$HOME/.dotfiles"
    fi
}

# creates dirs if not already there
createDirs() {

    if [ ! -d "$HOME/.config" ]; then
        CHANGED=true
        echo "Creating .config dir..."
        mkdir -p "$HOME/.config"
    fi

    if [ ! -d "$HOME/.local/bin" ]; then
        CHANGED=true
        echo "Creating .local/bin dir..."
        mkdir -p "$HOME/.local/bin"
    fi

    if [ ! -d "$HOME/.bashrc.d" ]; then
        CHANGED=true
        echo "Creating .bashrc.d dir..."
        mkdir -p "$HOME/.bashrc.d"
    fi
}

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

addBashrc() {

    # if user path isn't added already
    if ! grep -q "sets user path to" "$HOME/.bashrc"; then

        if grep -q "PATH" "$HOME/.bashrc"; then
            echo "[WARNING]: PATH is modified in .bashrc confirm this doesn't effect bootstrapping"
        fi

        CHANGED=true
        echo "Adding user path to .bashrc..."
        echo "$TOOLPATH" >> "$HOME/.bashrc"
    fi

    # adjust path if inside a container
    # and just always use mise for in and out
    if [ "$CONTAINER" = true ]; then
        if ! grep -q "mise tool shims" "$HOME/.bashrc"; then
            CHANGED=true
            echo "Adding mise tools to PATH"
            echo "$MISEPATH" >> "$HOME/.bashrc"
        fi
    fi

    # check if .bashrc.d isn't mentioned in .bashrc
    if ! grep -q "start of .bashrc.d config link" "$HOME/.bashrc" && ! grep -q ".bashrc.d" "$HOME/.bashrc"; then
        CHANGED=true
        echo "Adding .bashrc.d sourcing to .bashrc..."
        echo "$SOURCE" >> "$HOME/.bashrc"
    fi

    # Tmux logic check if host is a container
    if [[ $CONTAINER == true ]] && ! grep -q "start of devcontainer tmux config" "$HOME/.bashrc"; then
        CHANGED=true
        echo "Adding tmux sesssion auto attach to .bashrc..."
        echo "$TMUX" >> "$HOME/.bashrc"
    fi

    if ! grep -q "start of in Memory Creds config" "$HOME/.bashrc"; then
        CHANGED=true
        echo "Adding memory cred loading logic to .bashrc..."
        echo "$CRED" >> "$HOME/.bashrc"
    fi
}

# download mise if not already on the system with arch detection
downloadMise() {
    if [ ! -f "$MISEBIN" ]; then
        ARCH="$(uname -m)"
        case "$ARCH" in
            x86_64)  MISE_ARCH="x64" ;;
            aarch64) MISE_ARCH="arm64" ;;
            *) echo "ERROR Unsupported architecture: $ARCH" >&2; exit 1 ;;
        esac

        curl -Lo "$MISEBIN" "https://mise.jdx.dev/mise-latest-linux-$MISE_ARCH"
        chmod +x "$MISEBIN"
    fi
}

checkmise() {
    local name=$1
    local version=$2
    local tool=$name@$version

    if ! mise where "$tool" >/dev/null 2>&1; then
        $MISEBIN use -g "$tool"
        CHANGED=true
    fi
}

# gopass needs an age identity before it can store/read anything, and
# generating one requires a human to confirm a passphrase interactively
checkGopassSetup() {
    if ! gopass ls >/dev/null 2>&1; then
        echo "gopass has no password store set up yet."
        echo "Run this once, then source this script again to continue:"
        echo
        echo "    gopass setup --crypto age"
        echo
        return 1
    fi

    # cache the unlocked identity in a background agent
    if [[ "$(gopass config age.agent-enabled 2>/dev/null)" != "true" ]]; then
        gopass config age.agent-enabled true >/dev/null
        gopass config age.agent-timeout 28800 >/dev/null
        CHANGED=true
    fi
}

# Checks creds in gopass and prompts user to provide key if not found
Creds() {
    local credPath=$1
    if ! gopass show -o "$credPath" >/dev/null 2>&1; then

        echo "[WARNING]: API key not found in ($credPath)"
        read -rsp "Enter your API Key: " input

        if [ -n "$input" ]; then
            if echo "$input" | gopass insert -f "$credPath" >/dev/null 2>&1; then
                if gopass show "$credPath" >/dev/null 2>&1; then
                    echo "Key saved to gopass..."
                else
                    echo "[ERROR]: Key was written but gopass failed to read"
                fi
            else
                echo "[ERROR]: 'gopass insert' command failed"
            fi
        else
            echo "[ERROR]: Empty key provided. Source bootstrap script again"
        fi
    fi
}

bootStrap() {
    containerCheck
    createDirs

    # Links files downloaded from github to user environment config locations
    dotlink "bash/.bashrc.d/prompt.sh" ".bashrc.d/prompt.sh"
    dotlink "nvim" ".config/nvim"
    dotlink "tmux/.tmux.conf" ".tmux.conf"
    dotlink "bin/devup" ".local/bin/devup"
    dotlink "bin/devssh" ".local/bin/devssh"

    downloadMise

    # install/configure mise tools if not already installed
    checkmise "neovim" "$NEOVIM_VERSION"
    checkmise "tmux" "$TMUX_VERSION"
    checkmise "ripgrep" "$RG_VERSION"
    checkmise "fd" "$FD_VERSION"
    checkmise "fzf" "$FZF_VERSION"
    checkmise "python" "$PY_VERSION"
    checkmise "node" "$NODE_VERSION"
    checkmise "tree-sitter" "$TS_VERSION"
    checkmise "claude" "$CLAUDE_VERSION"
    checkmise "gopass" "$GOPASS_VERSION"

    addBashrc

    if [ -f "$HOME/.bashrc" ]; then
        shopt -s expand_aliases 2>/dev/null
        source "$HOME/.bashrc"
        echo "User bashrc reloaded into current shell session..."
    fi

    if ! checkGopassSetup; then
        GOPASSCHANGE=true
        return
    fi

    Creds "api/anthropic/claude-code"

    # remove any non-tracked mise related binaries
    if [[ -n "$("$MISEBIN" ls --prunable 2>/dev/null)" ]]; then
        echo "Removing old tools..."
        "$MISEBIN" prune --tools -y
    fi

    # output different based on CHANGED value
    if [[ "$CHANGED" == true || "$GOPASSCHANGE" == true ]]; then
        echo "Bootstrapping finished"
    else
        echo "System is already bootstrapped"
    fi
}

# add "$@" if wanting to forward args in the future
bootStrap
