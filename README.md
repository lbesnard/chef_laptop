# Provision home and work computer with CHEF
Provision home(amd64-i386) and work laptop after a fresh install of Linux
Mint XFCE 17 or plus

##  What does this install ?
this installs :
 * git repos
 * vim with vundle
 * tmux, zsh, zplug
 * cheats
 * dotfiles (aliases completes)
 * python, perl packages and setup
 * work software
 * paragliding and kayaking tools
 * games

## Installation

 * install private key to ```$HOME/.ssh``` (600)

```bash
curl -sSL https://raw.githubusercontent.com/lbesnard/chef_laptop/master/install.sh | bash
```

requires https://github.com/lbesnard/dotfiles to exist
