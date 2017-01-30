HOME_DIR = "/home/#{node['chef_laptop']['user']}"


# Install vagrant 1.7
remote_file "/tmp/vagrant.deb" do
  source "https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb"
  mode 0644
  checksum "dcd2c2b5d7ae2183d82b8b363979901474ba8d2006410576ada89d7fa7668336"
  use_conditional_get true
  not_if 'which vagrant | grep vagrant'
end

dpkg_package "vagrant" do
    source "/tmp/vagrant.deb"
    action :install
    ignore_failure true
    not_if 'which vagrant | grep vagrant'
end

# Install chef-dk , still need manual process
remote_file "/tmp/chef_dk_amd64.deb" do
  source "https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.17.17-1_amd64.deb"
  mode 0644
  checksum "e247a5cf850f7c693a50b4a2cff07c3b4184c0ec0678493dfcd612e377bda6fd"
  use_conditional_get true
end

dpkg_package "chef_dk" do
    source "/tmp/chef_dk_amd64.deb"
    action :install
    ignore_failure false
end


# install berkshelf
bash "install berkshelf" do
  cwd '/tmp'
  code <<-EOH
   command -v berks >/dev/null || vagrant plugin install berkshelf;
   EOH
   environment ({'HOME' => "#{HOME_DIR}" })
   user node['chef_laptop']['user']
   ignore_failure true
end

# install vagrant-berkshelf
bash "install vagrant-berkshelf" do
  cwd '/tmp'
  code <<-EOH
   plugin_list=`vagrant plugin list`; [[ ! $plugin_list == *vagrant-berkshelf* ]] && vagrant plugin install vagrant-berkshelf; exit 0
   EOH
   environment ({'HOME' => "#{HOME_DIR}" })
   user node['chef_laptop']['user']
   ignore_failure true
   #return [0]
   #return [0,1]
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

# create TALEND link
link "#{HOME_DIR}/Desktop/Talend" do
   to "/opt/TOS_DI-r96646-V5.1.3/TOS_DI-linux-gtk-x86_64"
   user node['chef_laptop']['user']
   group node['chef_laptop']['group']
   ignore_failure true
end
