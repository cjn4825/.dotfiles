# ~/.bashrc.d/prompt.sh

# Git branch and uncommitted status
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

HOST=''

# to see if host is a container or not
if [ -f /.dockerenv ]; then
	HOST="docker"
else
	HOST="\h"
fi

GREEN='\[\033[01;32m\]'
BLUE='\[\033[01;34m\]'
ORANGE='\[\033[0;33m\]'
RESET='\[\033[00m\]'

PS1="${debian_chroot:+($debian_chroot)}${GREEN}\u@\$HOST${RESET}:${BLUE}\w${ORANGE} \$(parse_git_branch)${RESET}\$ "
