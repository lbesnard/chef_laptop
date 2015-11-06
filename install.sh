#!/bin/bash
# run as root
chef_binary=/usr/bin/chef-solo

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    aptitude update &&
    apt-get --asume-yes true install chef
fi

# backup and remove passphrase
#cp ~/.ssh/id_rsa ~/.ssh/id_rsa.backup
#openssl rsa -in ~/.ssh/id_rsa -out ~/.ssh/id_rsa_new
#cp ~/.ssh/id_rsa_new ~/.ssh/id_rsa
#ssh-agent
#ssh-add

echo "provision chef"
"$chef_binary" -c chef_laptop.rb -j chef_laptop.json


command -v calibre >/dev/null && echo "calibre Found In \$PATH" || \
  (sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | \
    sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()")
