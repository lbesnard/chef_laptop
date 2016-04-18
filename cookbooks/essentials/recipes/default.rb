HOME_DIR = "/home/#{node['chef_laptop']['user']}"

directory '/opt' do
   owner node['chef_laptop']['user']
   group node['chef_laptop']['user']
   mode '0755'
   action :create
end

directory "#{HOME_DIR}/paragliding" do
   owner node['chef_laptop']['user']
   group node['chef_laptop']['user']
   mode '0755'
   action :create
end

# set plat for dropbox ...
if RUBY_PLATFORM == 'x86_64-linux'
  archDropbox = "amd64"
  archFpalc   = "linux-x86_64"
else
  archDropbox = "i386"
  archFpalc   = "linux-i686"
end
archFilebot = "#{archDropbox}"

remote_file "/tmp/filebot.deb" do
  source "http://downloads.sourceforge.net/project/filebot/filebot/FileBot_4.6.1/filebot_4.6.1_#{archFilebot}.deb"
  mode 0644
end

dpkg_package "FileBot" do
  source "/tmp/filebot.deb"
  action :install
  ignore_failure true
end

remote_file "/tmp/dropbox.deb" do
  source "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_#{archDropbox}.deb"
  mode 0644
end

dpkg_package "Dropbox" do
  source "/tmp/dropbox.deb"
  action :install
  ignore_failure true
end

##  handbrake
apt_repository 'handbrake' do
  uri       'http://ppa.launchpad.net/stebbins/handbrake-releases/ubuntu'
  components ['raring', 'main']
end

essentials  = %w{bum xmlindent cmake xvfb shunit2 yajl-tools txt2regex emacs whois devscripts keepass2 xdotool kpcli chromium-browser guake git bash-completion sshfs gt5 gftp dropbox gtg screen time unrar unzip  p7zip  cowsay curl twitter-recess source-highlight build-essential x11-utils pdfposter xsltproc libxml2-utils}
network     = %w{gufw elinks irssi libnotify-bin dnsmasq dnsmasq-utils lighttpd network-manager network-manager-gnome network-manager-openvpn network-manager-openvpn-gnome network-manager-pptp  network-manager-pptp-gnome  network-manager-vpnc  network-manager-vpnc-gnome ngrep strace transmission-gtk}
java        = %w{ant}
make_deb_pckg= %w{automake autoconf libtool pkg-config libcurl4-openssl-dev intltool libxml2-dev libgtk2.0-dev libnotify-dev libglib2.0-dev libevent-dev checkinstall}
netcdf      = %w{netcdf-bin nco ncview hdf4-tools hdf5-helpers hdf5-tools hdfview}
vm          = %w{virtualbox virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11 bundler rbenv gem }
# timidity tuxguitar-jsa to solve conflict with tuxguitar
guitar      = %w{tuxguitar timidity tuxguitar-jsa}
multimedia  = %w{mp3blaster vlc vlc-data vlc-nox vlc-plugin-notify vlc-plugin-pulse clementine darktable handbrake xchat skype imagemagick youtuBE-DL easytag cantata gmpc}
pdf         = %w{scantailor pdfmod}
db          = %w{mdbtools mdbtools-gmdb  sqlite3 sqlitebrowser pgadmin3 postgresql-9.4 tomcat7 tomcat7-admin tomcat7-common tomcat7-docs}
janus       = %w{ruby-dev rake exuberant-ctags ack-grep}
raspberrypi = %w{tightvncserver}
beets       = %w{python-gi gstreamer0.10-plugins-good gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly spark}
paragliding = %w{freeglut3 freeglut3-dev gnuplot perl-tk xterm gnuplot-x11 python-geopy}
packages    = [ essentials, network, java, make_deb_pckg, netcdf, vm, guitar, multimedia, pdf, db, janus, raspberrypi, beets, paragliding ]

packages.flatten.each do |a_package|
  package a_package
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
     echo "fpcalc Found In \$PATH" || ( curl -L https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-fpcalc-1.1-#{archFpalc}.tar.gz \
     -o /tmp/chromaprint.tar.gz &&  tar -xvf /tmp/chromaprint.tar.gz  -C /tmp/ && \
     cp /tmp/chromaprint-fpcalc-1.1-#{archFpalc}/fpcalc /usr/local/bin)
   EOH
   environment ({'HOME' => "#{HOME_DIR}" })
   user "root"
   ignore_failure true
end

# install paragliding tools
cpan_module 'Imager'
cpan_module 'Image::ExifTool'
cpan_module 'Image::PNG'

execute "flight recorder" do
 command "pip install flightrecorder"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end
