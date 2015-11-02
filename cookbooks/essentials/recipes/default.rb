HOME_DIR = "/home/#{node['chef_laptop']['user']}"

# Install dropbox , still need manual process
remote_file "/tmp/dropbox_1.6.2_amd64.deb" do
  source "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.2_amd64.deb"
  mode 0644
  checksum "58f0340db9f03fb054eb6bc86598de194f7fce8bec2f4870a8d4065277b0cc38" # PUT THE SHA256 CHECKSUM HERE
end

dpkg_package "dropbox" do
  source "/tmp/dropbox_1.6.2_amd64.deb"
  action :install
  ignore_failure true
  notifies :run, "execute[install-deps]", :immediately
end


##  handbrake
apt_repository 'handbrake' do
  uri       'http://ppa.launchpad.net/stebbins/handbrake-releases/ubuntu'
  components ['raring','main']
end




essentials = %w{yajl-tools txt2regex emacs whois devscripts keepass2 xdotool kpcli chromium-browser guake git bash-completion sshfs gt5 gftp dropbox gtg screen time unrar unzip  p7zip  cowsay curl twitter-recess source-highlight build-essential }
network    = %w{elinks irssi libnotify-bin dnsmasq dnsmasq-utils lighttpd network-manager network-manager-gnome network-manager-openvpn network-manager-openvpn-gnome network-manager-pptp  network-manager-pptp-gnome  network-manager-vpnc  network-manager-vpnc-gnome ngrep strace transmission-gtk}
java = %w{ant}
netcdf = %w{netcdf-bin nco ncview hdf4-tools hdf5-helpers hdf5-tools hdfview}
vm = %w{vagrant virtualbox-4.3 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11}
# timidity tuxguitar-jsa to solve conflict with tuxguitar
multimedia = %w{tuxguitar timidity tuxguitar-jsa mp3blaster vlc vlc-data vlc-nox vlc-plugin-notify vlc-plugin-pulse clementine darktable handbrake xchat skype imagemagick youtuBE-DL easytag}
db = %w{mdbtools mdbtools-gmdb  sqlite3 sqlitebrowser pgadmin3 postgresql-9.3 tomcat7 tomcat7-admin tomcat7-common tomcat7-docs}
janus = %w{ruby-dev rake exuberant-ctags ack-grep}
raspberrypi = %w{tightvncserver}
beets = %w{gstreamer1.0 python-gi gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly spark}
packages = [ essentials, network, java, netcdf, vm, multimedia, db, janus, raspberrypi, beets ]

packages.flatten.each do |a_package|
  package a_package
end

# Install ncBrowse
bash "install ncBrowse" do
  cwd '/tmp'
  code <<-EOH
  curl -L "ftp://ftp.epic.noaa.gov/java/ncBrowse/InstData/Linux/VM/install_rel1_6_7.bin" -o /tmp/ncBrose.bin
  chmod +x /tmp/ncBrowse.bin;
  sh /tmp/ncBrowse.bin;
  EOH
  environment ({'HOME' => '#{HOME_DIR}' })
  ignore_failure true
end

# Install btsync
remote_file "/tmp/btsync.tar.gz" do
  source "http://download.getsyncapp.com/endpoint/btsync/os/linux-x64/track/stable"
  ignore_failure true
end

bash "unpack btsync" do
  cwd '/tmp'
  code <<-EOH
  tar xzvf /tmp/btsync.tar.gz -C /tmp;
  cp /tmp/btsync #{HOME_DIR}/bin/btsync;
  ~/bin/btsync;
  EOH
  environment ({'HOME' => '#{HOME_DIR}' })
  ignore_failure true
end


# install janus for vim
bash "install janus" do
  cwd '#{HOME_DIR}'
  code <<-EOH
   mkdir -p #{HOME_DIR}/.vim;
   if [ -f #{HOME_DIR}/.vim/Rakefile ]
   then
       cd #{HOME_DIR}/.vim && rake
   else
       curl -Lo- http://bit.ly/janus-bootstrap | bash
   fi
   EOH
   environment ({'HOME' => '#{HOME_DIR}' })
   user "lbesnard"
   ignore_failure true
end


# autostart guake
execute "autostart guake" do
  command "ln -s /usr/share/applications/guake.desktop /etc/xdg/autostart/"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end

# install beet mp3 tag
execute "beet_install" do
  command "pip install beets; pip install flask; pip install pylast; pip install pyacoustid; pip install discogs-client"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end

bash "install chromaprint for beets" do
  cwd '#{HOME_DIR}'
  code <<-EOH
   curl -L https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-fpcalc-1.1-linux-x86_64.tar.gz -o /tmp/chromaprint.tar.gz | bash
   tar -xvf /tmp/chromaprint.tar.gz  -C /tmp/
   cp /tmp/chromaprint-fpcalc-1.1-linux-x86_64/fpcalc /usr/local/bin
   EOH
   environment ({'HOME' => '#{HOME_DIR}' })
   user "lbesnard"
   ignore_failure true
end
