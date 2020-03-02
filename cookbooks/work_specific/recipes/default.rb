HOME_DIR = "/home/#{node['chef_laptop']['user']}"


# Install vagrant 1.7
remote_file "/tmp/vagrant.deb" do
  source "https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.deb"
  mode 0644
  checksum "cee18b6f3b1209ea5878c22cfd84a9f0004f20ef146cb7a18aada19162928a0f"
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
  source "https://packages.chef.io/files/stable/chefdk/1.3.40/ubuntu/16.04/chefdk_1.3.40-1_amd64.deb"
  mode 0644
  checksum "77bbd40587b0411387fe444bef6675f6e3157219e94dc792f247b3a44f172ba5"
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
end

# install vbguest to avoid mount folders issues
bash "install vagrant-vbguest" do
  cwd '/tmp'
  code <<-EOH
   plugin_list=`vagrant plugin list`; [[ ! $plugin_list == *vagrant-vbguest* ]] && vagrant plugin install vagrant-vbguest; exit 0
   EOH
   environment ({'HOME' => "#{HOME_DIR}" })
   user node['chef_laptop']['user']
   ignore_failure true
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
