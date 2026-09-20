#!/usr/bin/env bash

# only run in interactive shells
if [[ $- == *i* ]]; then

    # check if we are already in tmux session
    if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then

        # attach if the session exists otherwise create one
        tmux a -t 0 >/dev/null 2>&1 || tmux new-session -s 0 >/dev/null 2>&1

        exit 0
    fi
fi
