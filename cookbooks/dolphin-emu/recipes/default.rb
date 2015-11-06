# Install dropbox
remote_file "/tmp/dolphin_4.0-5242_amd64.deb" do
  source "http://dl.dolphin-emu.org/builds/dolphin-master-4.0-5242_amd64.deb"
  mode 0644
  checksum "8eb0b2552aef04181fa91093a26def94d924dfb962810199e716ac67777b8cf9" # PUT THE SHA256 CHECKSUM HERE
end


dpkg_package "dolphin-emu" do
  source "/tmp/dolphin_4.0-5242_amd64.deb"
  action :install
  ignore_failure true
  #notifies :run, "execute[install-deps]", :immediately
end

execute "install dolphin deps" do
  command "apt-get -yf install"
  action :run
  ignore_failure true
end
