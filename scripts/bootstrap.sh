#!/usr/bin/env bash

# This script is for bootstrapping environments for neovim use
# Works as a way to package all the tooling I need for
# neovim without needing root access to the system
# as well as any tools pre/post installed when given
# access manually

CONTAINER=false
USERBIN="$HOME/.local/bin"
MISEBIN="$USERBIN/mise"

SOURCE="
# --- start of .bashrc.d config link ---
if [ -d \"\$HOME/.bashrc.d\" ]; then
    for file in \"\$HOME/.bashrc.d/\"*; do
        [ -r \"\$file\" ] && . \"\$file\"
    done
fi
unset file
# --- end of .bashrc.d config link ---"

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

dotlink() {

    local dotLocation="$DOTFILES/$1"
    local confLocation="$HOME/$2"

    # if already linked then nothing is linked otherwise force it
    if [ "$(readlink -f "$confLocation")" != "$dotLocation" ]; then
        echo "Linking [$dotLocation] -> [$confLocation]"
        rm -rf "$confLocation"
        ln -sfn "$dotLocation" "$confLocation"
    fi
}

# download mise if not already on the system with arch detection
# also install tools and clean up
setupMise() {

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

    mise trust "$HOME/.dotfiles/mise/config.toml" >/dev/null 2>&1

    if mise ls --missing 2>&1 | grep -q .; then
        mise install -y
    fi

    if [[ -n "$("$MISEBIN" ls --prunable 2>/dev/null)" ]]; then
        echo "Removing old tools..."
        "$MISEBIN" prune --tools -y
    fi
}

gopassSetup() {

    mkdir -p "$HOME/.config/gopass/"

    if ! gopass ls >/dev/null 2>&1; then
        GOPASS_AGE_STDIN_PASSPHRASE=1 gopass setup --crypto age

        read -rp "How many secrets do you want to insert: " count

        for ((i=0; i<count; i++))
        do
            read -rsp "Secret value: " secret
            read -rp "Location of key in vault: " location
            echo "$secret" | gopass insert -f -e "$location"
            echo "Secret inserted"
        done
    fi
}

bootStrap() {
    containerCheck

    mkdir -p "$HOME/.bashrc.d"
    dotlink "bash/.bashrc.d/toolpath.sh" ".bashrc.d/toolpath.sh"
    dotlink "bash/.bashrc.d/prompt.sh" ".bashrc.d/prompt.sh"

    if [[ $CONTAINER == true ]]; then
        dotlink "bash/.bashrc.d/tmuxcontainer.sh" ".bashrc.d/tmuxcontainer.sh"
    else
        dotlink "bash/.bashrc.d/sshagent.sh" ".bashrc.d/sshagent.sh"
    fi

    mkdir -p "$HOME/.config"
    dotlink "nvim" ".config/nvim"

    dotlink "tmux/.tmux.conf" ".tmux.conf"

    mkdir -p "$HOME/.local/bin"
    dotlink "bin/devup" ".local/bin/devup"

    dotlink "bin/devssh" ".local/bin/devssh"
    dotlink "bin/devc" ".local/bin/devc"

    mkdir -p "$HOME/.config/mise"
    dotlink "mise/config.toml" ".config/mise/config.toml"

    setupMise

    if ! grep -q ".bashrc.d" "$HOME/.bashrc"; then
        echo "Adding .bashrc.d sourcing to .bashrc..."
        echo "$SOURCE" >> "$HOME/.bashrc"
    fi

    if [ -f "$HOME/.bashrc" ]; then
        shopt -s expand_aliases 2>/dev/null
        source "$HOME/.bashrc"
    fi

    gopassSetup

    echo "Bootstrapping finished!"
}

bootStrap
