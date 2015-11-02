#!/bin/bash

# Usage: ./deploy.sh [host]
# see http://www.opinionatedprogrammer.com/2011/06/chef-solo-tutorial-managing-a-single-server-with-chef/
host="${1:-lbesnard-Latitude-E6320}"

sudo bash install.sh
# TOTO : run the script a second time which will fix dependency issues.
# Def a bit dodg, but quicker to fix this way
sudo bash install.sh
