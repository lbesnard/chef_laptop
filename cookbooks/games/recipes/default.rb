HOME_DIR = "/home/#{node['chef_laptop']['user']}"


##  quake repo
execute "zandronum" do
 command "add-apt-repository 'deb http://debian.drdteam.org/ stable multiverse';wget -O - http://debian.drdteam.org/drdteam.gpg | apt-key add -;apt-get update;"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end


## snes repo
execute "snes9x-gtk" do
 command  "add-apt-repository -y ppa:bearoso/ppa; apt-get update;"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end

# cleaning
execute "cleaning" do
 command  "apt-get install --assume-yes force;apt-get update;"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end

# retroach
#execute "retroarch" do
 #command  "add-apt-repository -y ppa:hunter-kaller/ppa; apt-get update;"
  #action :run
  #environment ({'HOME' => '#{HOME_DIR}'})
  #ignore_failure true
  #user "root"
#end

games = %w{dos2unix doom-wad-shareware doomseeker doomseeker-zandronum gzdoom ioquake3 ioquake3-dbg ioquake3-server zsnes playonlinux wine1.6  zandronum zandronum-client zandronum-pk3 zandronum-server}
packages = [games]

packages.flatten.each do |a_package|
  package a_package
end
