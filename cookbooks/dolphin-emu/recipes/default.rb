# Install dropbox
remote_file "/tmp/dolphin_4.0-5242_amd64.deb" do
  source "http://dl.dolphin-emu.org/builds/dolphin-master-4.0-5242_amd64.deb"
  mode 0644
  checksum "8eb0b2552aef04181fa91093a26def94d924dfb962810199e716ac67777b8cf9" # PUT THE SHA256 CHECKSUM HERE
end


execute "dependancies" do
  command "apt-get -f install"
  action :run
  environment ({'HOME' => '/home/lbesnard'})
  ignore_failure true
end


dpkg_package "dolphin-emu" do
  source "/tmp/dolphin_4.0-5242_amd64.deb"
  action :install
  ignore_failure true
end

