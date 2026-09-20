# Dotfiles

Includes dotfiles used for my fast, and relatively minimal development setup built on [Neovim](https://neovim.io/). This project is semi-contained (only need git), with the tools installed through [Mise](https://mise.jdx.dev/); details can be found within the Scripts/bootstrap.sh file on how it is implemented. Additionally, [Gopass](https://github.com/gopasspw/gopass) is used as a secrets manager which encrypts using the 'age' crypto backend, and serves as a way to quickly and securely add secrets needed on a host.

This is entirely interactive where the user is only prompted to input a passphrase and insert secrets related to gopass, other then that this is all automated and I think its pretty cool.

# Usage

## Code
```bash
# go to home dir
git clone https://github.com/cjn4825/.dotfiles.git

# source script
source ~/.dotfiles/scripts/bootstrap.sh

# follow the rest of the prompts to continue configuring gopass
```

## Install tools

Add the tool name and version in the config.toml file in /mise. Then re-source the script.

## Remove tools

To remove tools, use the 'uninstall' command if you want to remove the binary on your system while keeping it defined in the toml file.

```bash
mise uninstall [tool name]
```

Or use the 'rm' command if you want to remove both the binary file and the toml file.

```bash
mise rm [tool name]
```

## What this does
These dotfiles are designed to work without any dependencies via mise and include all the tools needed, such as npm and python for building the linters and formatters. This script modifies ~/.bashrc and works within devcontainers and normal environments as well as most architectures.

# Folders

## nvim
Includes the bulk and focus of this project, which is all the config files needed for Neovim to work like how I want it to.

## bash
Includes cosmetic changes I've made to the command prompt line, which includes colors that match the theme, username, and hostname on the system, and a status that shows what git branch you're in.

## tmux
Includes config files needed for tmux, the multiplexer I use, so that I can have multiple terminals and windows open, and contains the logic of how it interacts with Neovim for seamless switching.

## mise
Includes config toml file that indicates which tools should be installed with mise.

## bin
Includes some simple wrapper bash scripts to run tools such as devpod and claude in a specific way. More details can be found within the scripts.

# Example of Environment

Disclaimer: Your Neovim most likely won't look like this due to the desktop terminal emulator being used. Mine is customized with a gruvbox theme.

![example picture](nvim/Neovim_example.png)
