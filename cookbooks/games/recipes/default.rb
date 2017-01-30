HOME_DIR = "/home/#{node['chef_laptop']['user']}"


# cleaning
execute "cleaning" do
 command  "apt-get install --assume-yes force;apt-get update;"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end


games = %w{mess dos2unix doom-wad-shareware doomseeker doomseeker-zandronum gzdoom ioquake3 ioquake3-dbg ioquake3-server zsnes playonlinux wine1.6}
packages = [games]

packages.flatten.each do |a_package|
  package a_package
end
