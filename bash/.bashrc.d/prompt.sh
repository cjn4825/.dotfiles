#!/usr/bin/env bash

# Git branch and uncommitted status
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Gruvbox Colors
GRUVBOX_BLUE='\[\033[38;5;109m\]'
GRUVBOX_GREEN='\[\033[38;5;142m\]'
GRUVBOX_YELLOW='\[\033[38;5;214m\]'
GRUVBOX_RESET='\[\033[0m\]'

PS1="${GRUVBOX_GREEN}\u${GRUVBOX_GREEN}@${GRUVBOX_GREEN}\h${GRUVBOX_RESET} ${GRUVBOX_BLUE}\w${GRUVBOX_YELLOW}\$(parse_git_branch)${GRUVBOX_RESET} $ "
