# Install dropbox
remote_file "/tmp/dropbox_1.6.2_amd64.deb" do
  source "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.2_amd64.deb"
  mode 0644
  checksum "58f0340db9f03fb054eb6bc86598de194f7fce8bec2f4870a8d4065277b0cc38" # PUT THE SHA256 CHECKSUM HERE
end

dpkg_package "dropbox" do
  source "/tmp/dropbox_1.6.2_amd64.deb"
  action :install
end


##  handbrake
apt_repository 'handbrake' do
  uri       'http://ppa.launchpad.net/stebbins/handbrake-releases/ubuntu'
  components ['raring','main']
end




essentials = %w{devscripts chromium-browser guake git bash-completion sshfs gt5 gftp dropbox gtg screen time unrar unzip  p7zip  cowsay curl twitter-recess source-highlight build-essential }

network    = %w{network-manager network-manager-gnome network-manager-openvpn network-manager-openvpn-gnome network-manager-pptp  network-manager-pptp-gnome  network-manager-vpnc  network-manager-vpnc-gnome ngrep strace transmission-gtk}

java = %w{ant}


netcdf = %w{netcdf-bin nco ncview hdf4-tools hdf5-helpers hdf5-tools hdfview}

vm = %w{vagrant virtualbox-4.3 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11}

multimedia = %w{vlc vlc-data vlc-nox vlc-plugin-notify vlc-plugin-pulse clementine darktable handbrake xchat skype imagemagick youtuBE-DL}

db = %w{mdbtools mdbtools-gmdb  sqlite3 sqlitebrowser pgadmin3 postgresql-9.3 tomcat7 tomcat7-admin tomcat7-common tomcat7-docs}

packages = [essentials, network ,java, netcdf , vm,multimedia, db]

packages.flatten.each do |a_package|
  package a_package
end
