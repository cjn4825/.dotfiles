#!/usr/bin/env bash

# adds ssh socket to allow devpod to forward credentials for devpod
export SSH_AUTH_SOCK="$HOME/.ssh/ssh-agent.sock"

ssh-add -l > /dev/null 2>&1
status=$?

# 2 = can't reach the agent at all (dead/stale socket)
if [ "$status" -eq 2 ]; then
    rm -f "$SSH_AUTH_SOCK"
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" > /dev/null
    status=1
fi

# 1 = agent is alive but has no keys loaded yet
if [ "$status" -ne 0 ]; then
    ssh-add "$HOME/.ssh/id_rsa"
fi
