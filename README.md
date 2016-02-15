# Provision home and work computer with CHEF
Provision home(amd64-i386) and work laptop after a fresh install of Linux
Mint XFCE 17 or plus

##  ?
this installs :
 * git repos
 * janus for vim
 * dotfiles (aliases completes)
 * python, perl packages and setup
 * work software
 * paragliding and kayaking tools
 * games

## Installation

 * install dropbox manually and connect
 * copy id_rsa private key to $HOME/.ssh (600)
 * ```mkdir $HOME/github_repo && cd $HOME/github_repo ; sudo apt-get -y install git && git clone https://github.com/lbesnard/chef_laptop```
 * ```sudo -HE $HOME/github_repo/chef_laptop/install.sh```
```

requires https://github.com/lbesnard/dotfiles to exist

## random things re vim as python IDE
see
http://blog.dispatched.ch/2009/05/24/vim-as-python-ide/
http://stackoverflow.com/questions/9172802/setting-up-vim-for-python
http://www.sontek.net/blog/2011/05/07/turning_vim_into_a_modern_python_ide.html
https://github.com/carlhuda/janus
