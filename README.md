# Development Environment Files 

Includes dot files used for my customized, fast, and relatively minimal development setup built on [Neovim](https://neovim.io/).
In the process of reducing the number of plugins needed to complete tasks without limiting features, it includes dot files for other dependencies within Neovim.

# Reasoning

One summer, I bought an older laptop with the goal of installing some Linux distribution and learn more about it. At the time, I was thinking this laptop would be some sort of hacking lab or something, and I had the idea to try to use the Command Line whenever I could. I tried nano, then emacs, but settled on Neovim due to its customizability and documentation availability. After months and months of researching and getting comfortable using it, I started to appreciate and have a better feel for Linux in general. These dotfiles are used for the Neovim config.

# Usage

## Code
```bash
git clone https://github.com/cjn4825/.dotfiles.git
source ~/.dotfiles/scripts/bootstrap.sh
```

## What this does
These dotfiles are designed to work without any dependencies (besides git) and include all the tools needed, such as npm and python for building the linters and formatters. This script modifies ~/.bashrc and works within devcontainers and normal environments as well.  

# Folders

## nvim
This includes the bulk and focus of this project, which is all the config files needed for Neovim to work like how I want it to...again, it's a work in progress, so there WILL be errors that pop up now and again, but will be fixed soon.

## bash
This includes cosmetic changes I've made to the command prompt line, which includes colors that match the theme, username, and hostname on the system, and a status that shows what git branch you're in.

## tmux
This includes config files needed for tmux, the multiplexer I use, so that I can have multiple terminals and windows open, and contains the logic of how it interacts with Neovim for seamless switching.

## fonts/firacode
This includes the Firacode font. The font allows for the use of devicons, which make the whole look of Neovim much better.

# Skills Gained

By building and using this environment for more than a year now, I've gained and improved skills in:

* Linux Proficiency: daily terminal workflow, Package management, file permissions, system navigation, symbolic links, file systems, user permissions, and management
* Shell Proficiency: Bash usage, shell scripting, tmux multiplexer
* Programming aid: Language Server Protocols with languages such as Python, Bash, and Lua 
* Configuration Management: environment variables, modular Lua configuration, plugin management with Packer, and maintaining dotfiles to my liking
* Version Control: Git integration directly inside Neovim with Lazygit for easy remote syncing (probably get rid of later since I use git in another tmux pane most times)

# Example of Environment

Disclaimer: Your Neovim most likely won't look like this due to the desktop terminal emulator being used. The default terminal in Fedora with a gruvbox theme being used will look close, but mine is customized. In the process of somehow including this within the Dev-Container project...don't know if that's possible or not.

![example picture](nvim/Neovim_example.png)
