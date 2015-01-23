#!/bin/bash

# Usage: ./deploy.sh [host]
# see http://www.opinionatedprogrammer.com/2011/06/chef-solo-tutorial-managing-a-single-server-with-chef/
host="${1:-testubuntu@opinionatedprogrammer.com}"


sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install.sh

