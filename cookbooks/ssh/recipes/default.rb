HOME_DIR = "/home/#{node['chef_laptop']['user']}"

directory "#{HOME_DIR}/.ssh" do
  owner node['chef_laptop']['user']
  group node['chef_laptop']['group']
  action :create
  ignore_failure true
end

file "#{HOME_DIR}/.ssh/id_rsa.pub" do
   owner node['chef_laptop']['user']
   group node['chef_laptop']['group']
   mode "0600"
   content node['chef_laptop']['public_key']
   action :create
end
