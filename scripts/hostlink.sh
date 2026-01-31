#!/usr/bin/env bash
set -e

# this link is only for local host that ideally has no tools
# except devpod and other tools needed to run the current
# project specific devcontainer setup i have

# for now just links the devup script to user path

ln -sfn "$HOME/.dotfiles/bin/devup" "$HOME/.local/bin/devup"
