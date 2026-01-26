#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"

export BREW_HOME="$HOME/.linuxbrew"

# creates .config if not already
if [ ! -d $HOME/.config ]; then
    echo "Creating .config dir..."
    mkdir -p $HOME/.config
fi

# creates .local/bin for binaries
if [ ! -d $HOME/.local/bin ]; then
    echo "Creating .local/bin dir..."
    mkdir -p $HOME/.local/bin
fi

# creates homebrew home dir if not already
if [ ! -d $BREW_HOME/bin ]; then
    echo "Creating .linuxbrew/bin dir..."
    mkdir -p "$BREW_HOME/bin"
fi

slink() {
    local dotLocation="$DOTFILES/$1"
    local confLocation="$HOME/$2"

    echo "linking $dotLocation to $confLocation"
    ln -sfn "$dotLocation" "$confLocation"
}

echo "Linking dotfiles to host..."

# Links files downloaded from github to user environment config locations
slink "bash/.bashrc.d" ".bashrc.d"
slink "nvim" ".config/nvim"
slink "tmux/.tmux.conf" ".tmux.conf"

echo "Dotfiles linked to config dirs"
echo "Appending source spript to .bashrc..."

# add .bashrc.d to be sourced by .bashrc
SCRIPT='
# --- start of dotfiles config link ---
for file in "$HOME/.bashrc.d"/*; do
    [ -r "$file" ] && . "$file"
done
unset file
# --- end of dotfile config link ---
'
# append the script to .bashrc
echo "$SCRIPT" >> "$HOME/.bashrc"

# ------------------------------------------working-----------------------------------------------

curl -Lo eget.sh https://zyedidia.github.io/eget.sh
bash eget.sh
rm eget.sh
mv eget $HOME/.local/bin/

eget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    --file nvim-linux-x86_64/bin/nvim \
    --to $HOME/.local/bin

# eget tmux/tmux
# eget junegunn/fzf
# eget sharkdp/fd
# eget BurntSushi/ripgrep

# install neovim tar
# echo "Installing neovim..."
# curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
# | tar -xz -C "$HOME/.local/share/nvim-dist" --strip-components=1
# ln -sfn "$HOME/.local/nvim-dist/bin/nvim" "$HOME/.local/bin/nvim"

# # install tmux via community app image
# echo "Installing tmux..."
# curl -LO https://github.com/tmux/tmux-builds/releases/tmux-3.6a-linux-x86_64.tar.gz \
#     | tar -xz -C "$HOME/.local/bin/tmux-dist" --strip-components=1 \
# ln -sfn "$HOME/.local/bin/tmux-dist/bin/tmux" "$HOME/.local/bin/tmux"

# # install ripgrep dependency
# echo "Installing ripgrep..."
# curl -fsSL https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-x86_64-unknown-linux-musl.tar.gz \
#     | tar -xz -C "$HOME/.local/bin" --strip-components=1 --wildcards '*/rg'

# # install fd dependency
# curl -fsSL https://github.com/sharkdp/fd/releases/latest/download/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz \
#     | tar -xz -C "$HOME/.local/bin" --strip-components=1 --wildcards '*/fd'

# # install tree-sitter cli dependency
# # Since this is a .gz use gunzip
# curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz \
#     | gunzip -c > "$HOME/.local/bin/tree-sitter"
# chmod +x "$HOME/.local/bin/tree-sitter"

echo "Bootstrapping finished"
