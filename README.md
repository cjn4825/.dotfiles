# Development Environment Files 

Includes dot files used for my customized, fast, and relatively minimal development setup built on [Neovim](https://neovim.io/).
In the process of reducing the number of plugins needed to complete tasks without limiting features, and includes dot files for other dependencies within Neovim.

# Reasoning

One summer, I bought an older laptop for the goal of installing some Linux distribution and learn more about it. At the time, I was thinking this laptop would be some sort of hacking lab or something, and I had the idea to try to use the Command Line whenever I could. I tried nano, then emacs, but settled on Neovim due to its customizability and documentation availability. After months and months of researching and getting comfortable using it, I started to appreciate and have a better feel for Linux in general.

# Folders

## nvim
This includes the bulk and focus of this project, which is all the config files needed for Neovim to work like how I want it to...again its a work in progress so there WILL be errors that pop up now and again, but will be fixed soon.

## bash
This includes cosmetic changes i've made to the cmd prompt line which includes colors that match the theme, username and hostname on the system, and a status that shows what git branch you're in

## tmux
This includes config files needed for tmux; the multiplexer I use so that I can' have multiple terminals and windows open and contains logic of how it interacts with neovim for seamless switching

# Skills Gained

By building and using this environment for more than a year now, I've gained and improved skills in:

* Linux Proficiency: daily terminal workflow, Package management, file permissions, system navigation, symbolic links, file systems, user permissions and management
* Shell Proficiency: Bash usage, shell scripting, tmux multiplexer
* Programming aid: Language Server Protocols with languages such as C++, Python, Java, Bash, and Lua 
* Configuration Management: environment variables, modular Lua configuration, plugin management with Packer, and maintaining dotfiles to my liking
* Version Control: Git integration directly inside Neovim with Lazygit for easy remote syncing (problably get rid of later since i use git in another tmux pane most times)

# Example of Environment

Disclaimer: Your neovim most likely won't look like this due to the desktop terminal emulater being used. The default terminal in fedora with a gruvbox theme being used will look close but mine is customized. In the process of somehow including this within the Dev-Container project...don't know if that's possible or not.

![example picture](nvim/Neovim_example.png)
