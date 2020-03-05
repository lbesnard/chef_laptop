#!/usr/bin/env bash
local user=$USER
local github_repo=$HOME/github_repo
local chef_dir=$github_repo/chef_laptop
local chef_binary=/usr/bin/chef-solo

# install git
command -v git > /dev/null || sudo apt-get -y install git

# clone chef_laptop_repo
if [ ! -d  $chef_dir ]; then
    sudo -u $user mkdir -p $HOME/github_repo && cd $HOME/github_repo
    git clone https://github.com/lbesnard/chef_laptop --depth 1
fi

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    sudo aptitude update &&
    sudo apt-get --asume-yes true install chef
fi

sudo apt-get -y -f install
echo "provision chef"
cd $chef_dir
if [ `uname -m`  == "x86_64" ] ; then
    sudo -HE chef-solo -c chef_laptop.rb -j chef_laptop_x86_64.json
else
    sudo -HE chef-solo -c chef_laptop.rb -j chef_laptop_x86.json
fi


echo "install gpligc paragliding tool"
if [ `uname -m`  == "x86_64" ] ; then
    sudo dpkg -i $chef_dir/dpkg/gpligc_1.10pre7-1_amd64.deb
else
    sudo dpkg -i $chef_dir/dpkg/gpligc_1.10pre7-1_i386.deb
fi
