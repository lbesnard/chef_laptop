#!/bin/bash
# run as root
chef_binary=/usr/bin/chef-solo

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    aptitude update &&
    apt-get --asume-yes true install chef
fi &&

echo "provision chef"
"$chef_binary" -c solo.rb -j solo.json

.$HOME/bin/convert_repo_https_to_ssh.sh
