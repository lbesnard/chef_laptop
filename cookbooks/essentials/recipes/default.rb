HOME_DIR = "/home/#{node['chef_laptop']['user']}"

directory '/opt' do
   owner node['chef_laptop']['user']
   group node['chef_laptop']['user']
   mode '0755'
   action :create
end

# Install dropbox , still need manual process
remote_file "/tmp/dropbox_1.6.2_amd64.deb" do
  source "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.2_amd64.deb"
  mode 0644
  checksum "58f0340db9f03fb054eb6bc86598de194f7fce8bec2f4870a8d4065277b0cc38" # PUT THE SHA256 CHECKSUM HERE
  use_conditional_get true
end

dpkg_package "dropbox" do
  source "/tmp/dropbox_1.6.2_amd64.deb"
  action :install
  ignore_failure true
#  notifies :run, "execute[install-deps]", :immediately
end

# Install chef-dk , still need manual process
remote_file "/tmp/chef_dk_amd64.deb" do
  source "https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.9.0-1_amd64.deb"
  mode 0644
  checksum "26cfeef1cca36038cd4bea7f9bd7c7146b66e0dd08fc6a8a4b713bbb913b2967"
  use_conditional_get true
end

dpkg_package "chef_dk" do
    source "/tmp/chef_dk_amd64.deb"
    action :install
    ignore_failure true
end

##  handbrake
apt_repository 'handbrake' do
  uri       'http://ppa.launchpad.net/stebbins/handbrake-releases/ubuntu'
  components ['raring','main']
end


essentials = %w{yajl-tools txt2regex emacs whois devscripts keepass2 xdotool kpcli chromium-browser guake git bash-completion sshfs gt5 gftp dropbox gtg screen time unrar unzip  p7zip  cowsay curl twitter-recess source-highlight build-essential x11-utils}
network    = %w{elinks irssi libnotify-bin dnsmasq dnsmasq-utils lighttpd network-manager network-manager-gnome network-manager-openvpn network-manager-openvpn-gnome network-manager-pptp  network-manager-pptp-gnome  network-manager-vpnc  network-manager-vpnc-gnome ngrep strace transmission-gtk}
java = %w{ant}
netcdf = %w{netcdf-bin nco ncview hdf4-tools hdf5-helpers hdf5-tools hdfview}
vm = %w{vagrant virtualbox-4.3 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11 bundler rbenv gem }
# timidity tuxguitar-jsa to solve conflict with tuxguitar
multimedia = %w{tuxguitar timidity tuxguitar-jsa mp3blaster vlc vlc-data vlc-nox vlc-plugin-notify vlc-plugin-pulse clementine darktable handbrake xchat skype imagemagick youtuBE-DL easytag}
db = %w{mdbtools mdbtools-gmdb  sqlite3 sqlitebrowser pgadmin3 postgresql-9.3 tomcat7 tomcat7-admin tomcat7-common tomcat7-docs}
janus = %w{ruby-dev rake exuberant-ctags ack-grep}
raspberrypi = %w{tightvncserver}
beets = %w{python-gi gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly spark}
packages = [ essentials, network, java, netcdf, vm, multimedia, db, janus, raspberrypi, beets ]

packages.flatten.each do |a_package|
  package a_package
end

# Install ncBrowse
bash "install ncBrowse to /opt" do
  cwd '/tmp'
  code <<-EOH
    command -v ncBrowse >/dev/null && echo "ncBrowse Found In \$PATH" || ( curl -L "ftp://ftp.epic.noaa.gov/java/ncBrowse/InstData/Linux/VM/install_rel1_6_7.bin" \
     -o /tmp/ncBrowse.bin && chmod +x /tmp/ncBrowse.bin && sh /tmp/ncBrowse.bin && ln -s /opt/ncBrowse/ncBrowse /usr/bin/ncBrowse);
  EOH
  environment ({'HOME' => '#{HOME_DIR}' })
  ignore_failure true
end

## Install btsync
#remote_file "/tmp/btsync.tar.gz" do
#  source "http://download.getsyncapp.com/endpoint/btsync/os/linux-x64/track/stable"
#  ignore_failure true
#end

#bash "unpack btsync" do
#  cwd '/tmp'
#  code <<-EOH
#  tar xzvf /tmp/btsync.tar.gz -C /tmp;
#  cp /tmp/btsync #{HOME_DIR}/bin/btsync;
#  ~/bin/btsync;
#  EOH
#  environment ({'HOME' => '#{HOME_DIR}' })
#  ignore_failure true
#end


# install janus for vim
bash "install janus" do
  cwd "#{HOME_DIR}"
  code <<-EOH
   mkdir -p #{HOME_DIR}/.vim;
   if [ -f #{HOME_DIR}/.vim/Rakefile ]
   then
       cd #{HOME_DIR}/.vim && rake
   else
       curl -Lo- http://bit.ly/janus-bootstrap | bash
   fi
   EOH
   environment ({'HOME' => "#{HOME_DIR}" })
   user node['chef_laptop']['user']
   ignore_failure true
end


# autostart guake
execute "autostart guake" do
 command "cp /usr/share/applications/guake.desktop /etc/xdg/autostart/; chmod 644 /etc/xdg/autostart/guake.desktop;"
  action :run
  environment ({'HOME' => "#{HOME_DIR}"})
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
  cwd '/tmp'
  code <<-EOH
   command -v fpcalc >/dev/null && \
     echo "fpcalc Found In \$PATH" || ( curl -L https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-fpcalc-1.1-linux-x86_64.tar.gz \
     -o /tmp/chromaprint.tar.gz &&  tar -xvf /tmp/chromaprint.tar.gz  -C /tmp/ && \
     cp /tmp/chromaprint-fpcalc-1.1-linux-x86_64/fpcalc /usr/local/bin)
   EOH
   environment ({'HOME' => "#{HOME_DIR}" })
   user "root"
   ignore_failure true
end

# install calibre
#bash "calibre_install" do
#  cwd '/tmp'
#  code <<-EOH
#   sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
#  EOH
#  environment ({'HOME' => '#{HOME_DIR}'})
#  ignore_failure true
#  user node['chef_laptop']['user']
#end

directory '/mnt/imos-t4' do
   owner 'root'
   group 'root'
   mode '0755'
   action :create
   ignore_failure true
end

directory '/mnt/opendap' do
   owner 'root'
   group 'root'
   mode '0755'
   action :create
   ignore_failure true
end

directory '/mnt/opendap/1' do
   owner 'root'
   group 'root'
   mode '0755'
   action :create
   ignore_failure true
end

directory '/mnt/opendap/2' do
   owner 'root'
   group 'root'
   mode '0755'
   action :create
   ignore_failure true
end

# create TALEND link
link "#{HOME_DIR}/Desktop/Talend" do
   to "/opt/TOS_DI-r96646-V5.1.3/TOS_DI-linux-gtk-x86_64"
   user node['chef_laptop']['user']
   group node['chef_laptop']['group']
   ignore_failure true
end
