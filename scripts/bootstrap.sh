#!/usr/bin/env bash

# This script is for bootstrapping environments for neovim use
# Works as a way to package all the tooling I need for
# neovim without needing root access to the system
# as well as any tools pre/post installed when given
# access manually

#TODO:
    # remove dev_secrets.git repo
    # restart gopass conifg on both hosts
    # move text ouptut to readme? for the gopass setup
    # fix folder creation to look better

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

GOPASS="
gopass has no password store set up yet.

setup age crypto backend:

    gopass setup --crypto age

Make sure the vault is populated with the secrets you want:

    For example: gopass insert /foo/bar

Then just re-sourceing this script to finalize

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

# fix this to be better... ingegrate with dotlink better
createDirs() {

    if [ ! -d "$HOME/.config" ]; then
        echo "Creating .config dir..."
        mkdir -p "$HOME/.config"
    fi

    if [ ! -d "$HOME/.local/bin" ]; then
        echo "Creating .local/bin dir..."
        mkdir -p "$HOME/.local/bin"
    fi

    if [ ! -d "$HOME/.bashrc.d" ]; then
        echo "Creating .bashrc.d dir..."
        mkdir -p "$HOME/.bashrc.d"
    fi

    if [ ! -d "$HOME/.config/mise" ]; then
        echo "Creating .config/mise dir..."
        mkdir -p "$HOME/.config/mise"
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

addBashRc() {

    # if user path isn't added already
    if ! grep -q "sets user path to" "$HOME/.bashrc"; then

        if grep -q "PATH" "$HOME/.bashrc"; then
            echo "[WARNING]: PATH is modified in .bashrc confirm this doesn't effect bootstrapping"
        fi

        echo "Adding user path to .bashrc..."
        echo "$TOOLPATH" >> "$HOME/.bashrc"
    fi

    # adjust path if inside a container
    # and just always use mise for in and out
    if [ "$CONTAINER" = true ]; then
        if ! grep -q "mise tool shims" "$HOME/.bashrc"; then
            echo "Adding mise tools to PATH"
            echo "$MISEPATH" >> "$HOME/.bashrc"
        fi
    fi

    # check if .bashrc.d isn't mentioned in .bashrc
    if ! grep -q "start of .bashrc.d config link" "$HOME/.bashrc" && ! grep -q ".bashrc.d" "$HOME/.bashrc"; then
        echo "Adding .bashrc.d sourcing to .bashrc..."
        echo "$SOURCE" >> "$HOME/.bashrc"
    fi

    # Tmux logic check if host is a container
    if [[ $CONTAINER == true ]] && ! grep -q "start of devcontainer tmux config" "$HOME/.bashrc"; then
        echo "Adding tmux sesssion auto attach to .bashrc..."
        echo "$TMUX" >> "$HOME/.bashrc"
    fi

}

# gopass needs an age identity before it can store/read anything, and
# generating one requires a human to confirm a passphrase interactively
checkGopassSetup() {
    if ! gopass ls >/dev/null 2>&1; then
        echo "$GOPASS"
        return 1
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

sourceRc() {

    if [ -f "$HOME/.bashrc" ]; then
        shopt -s expand_aliases 2>/dev/null
        source "$HOME/.bashrc"
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
    dotlink "bin/devc" ".local/bin/devc"
    dotlink "mise/config.toml" ".config/mise/config.toml"

    setupMise
    addBashRc
    sourceRc

    if ! checkGopassSetup; then
        return
    fi

    # find way to prompt user for gopass input? for inserting secrets?
    # loop like how many secrets are you inputing? then loop for that amount

    echo "Bootstrapping finished"
}

bootStrap "$@"
