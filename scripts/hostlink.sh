#!/usr/bin/env bash
set -e

# this link is only for local host that ideally has no tools
# except devpod and other tools needed to run the current
# project specific devcontainer setup i have

# devup: builds and links dotfiles to container
# devssh: does a silent ssh so no error messages happen when exiting

ln -sfn "$HOME/.dotfiles/bin/devup" "$HOME/.local/bin/devup"
ln -sfn "$HOME/.dotfiles/bin/devssh" "$HOME/.local/bin/devssh"
