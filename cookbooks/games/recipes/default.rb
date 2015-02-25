##  quake repo
execute "zandronum" do
 command "sudo add-apt-repository 'deb http://debian.drdteam.org/ stable multiverse';wget -O - http://debian.drdteam.org/drdteam.gpg | sudo apt-key add -;sudo apt-get update;"
  action :run
  environment ({'HOME' => '/home/lbesnard'})
  ignore_failure true
end


## snes repo
execute "snes9x-gtk" do
 command  "sudo add-apt-repository -y ppa:bearoso/ppa; sudo apt-get update;"
  action :run
  environment ({'HOME' => '/home/lbesnard'})
  ignore_failure true

end

# cleaning
execute "cleaning" do
 command  "sudo apt-get install --assume-yes force;sudo apt-get update;"
  action :run
  environment ({'HOME' => '/home/lbesnard'})
  ignore_failure true

end

# retroach
execute "retroarch" do
 command  "sudo add-apt-repository ppa:hunter-kaller/ppa; sudo apt-get update;"
  action :run
  environment ({'HOME' => '/home/lbesnard'})
  ignore_failure true

end
games = %w{dos2unix doom-wad-shareware doomseeker doomseeker-zandronum gzdoom ioquake3 ioquake3-dbg ioquake3-server snes9x-gtk zsnes playonlinux wine1.6  zandronum zandronum-client zandronum-pk3 zandronum-server      libretro-snes9x retroarch libretro-bsnes libretro-snes9x-next }
packages = [games]

packages.flatten.each do |a_package|
  package a_package
end


