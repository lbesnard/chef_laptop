#!/usr/bin/env bash
user=$USER
chef_dir=$HOME/github_repo/chef_laptop
chef_binary=/usr/bin/chef-solo

# install git
command -v git > /dev/null || sudo apt-get -y install git

# clone repo
if [ ! -d  $chef_dir ]; then
    sudo -u $user mkdir -p $HOME/github_repo && cd $HOME/github_repo
    git clone https://github.com/lbesnard/chef_laptop
fi

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    sudo aptitude update &&
    sudo apt-get --asume-yes true install chef
fi

command -v keepass2 > /dev/null || sudo -v apt-get -y install keepass2

# install dropbox
if [ ! -d "$HOME/Dropbox" ]; then
    if [ `uname -m`  == "x86_64" ] ; then
        cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    else
        cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -
    fi

    (~/.dropbox-dist/dropboxd;)
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    mkdir -p "$HOME/.ssh"
    sudo -u $user chmod u+xr,go-rwx $HOME/.ssh
    echo "please install private key"
    exit 1
fi

ssh-add -t 1h

echo "provision chef"
cd $chef_dir
if [ `uname -m`  == "x86_64" ] ; then
    sudo -HE chef-solo -c chef_laptop.rb -j chef_laptop_x86_64.json
else
    sudo -HE chef-solo -c chef_laptop.rb -j chef_laptop_x86.json
fi

command -v calibre > /dev/null || \
    (sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | \
        sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()")

echo "install gpligc paragliding tool"
if [ `uname -m`  == "x86_64" ] ; then
    sudo dpkg -i $chef_dir/dpkg/gpligc_1.10pre7-1_amd64.deb
else
    sudo dpkg -i $chef_dir/dpkg/gpligc_1.10pre7-1_i386.deb
fi

# ctag for vim python
if [ `uname -m`  == "x86_64" ] ; then
    sudo dpkg -i $chef_dir/dpkg/ctags_5.8-1_amd64.deb
fi

# update vim automatically
vim +VundleClean +PluginInstall +qall
