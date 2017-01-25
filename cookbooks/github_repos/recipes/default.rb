HOME_DIR = "/home/#{node['chef_laptop']['user']}"
GITHUB_REPO = "/home/#{node['chef_laptop']['user']}/github_repo"

# clone all used repos
directory "#{GITHUB_REPO}" do
  mode 0755
  owner node['chef_laptop']['user']
  group node['chef_laptop']['group']
  user node['chef_laptop']['user']
  action :create
  ignore_failure true
end

github_repos = [  "lbesnard/dotfiles", \
                  "lbesnard/River_Height_Tasmania", \
                  "lbesnard/OSM_Tile_Download", \
                  "lbesnard/encryption", \
                  "lbesnard/BuildingMachineLearningSystemsWithPython", \
                  "aodn/chef", \
                  "aodn/chef-private", \
                  "aodn/harvesters", \
                  "aodn/imos-user-code-library", \
                  "twpayne/flightrecorder", \
                  "reicast/reicast-emulator", \
                  "ryanoasis/nerd-fonts", \
                  "gabrielelana/awesome-terminal-fonts", \
                  "powerline/fonts"\
                  ]

# co git repos using ssh key.  http://stackoverflow.com/questions/24024783/checkout-git-repo-with-chef-with-ssh-key
github_repos.flatten.each do |repo_name|
  # keep only the repo name part of the string
  name=repo_name.rpartition('/').last
  name.slice! ".git"

  git "#{GITHUB_REPO}/#{name}" do
    repository "ext::ssh -i #{HOME_DIR}/.ssh/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no git@github.com %S /#{repo_name}.git"
    reference "master"
    action :checkout
    enable_submodules true
    user node['chef_laptop']['user']
    group node['chef_laptop']['group']
    ignore_failure true
  end
end

execute "dotfiles" do
  command "bash #{GITHUB_REPO}/dotfiles/install"
  action :run
  environment ({'HOME' => "#{HOME_DIR}"})
  ignore_failure true
  user node['chef_laptop']['user']
  group node['chef_laptop']['group']
end

# install cheat
execute "cheat_install" do
  command "pip install docopt pygments;cd #{GITHUB_REPO}/dotfiles/libs/cheat; python setup.py install"
  action :run
  environment ({'HOME' => "#{HOME_DIR}"})
  ignore_failure true
  user "root"
end

execute "convert git repos https to git" do
  command "bash #{HOME_DIR}/bin/convert_repo_https_to_ssh.sh"
  action :run
  environment ({'HOME' => "#{HOME_DIR}"})
  ignore_failure true
  user node['chef_laptop']['user']
  group node['chef_laptop']['group']
end

execute "install various fonts" do
  command "bash #{GITHUB_REPO}/fonts/install.sh; bash #{GITHUB_REPO}/nerd-fonts/install.sh; bash #{GITHUB_REPO}/awesome-terminal-fonts/install.sh"
  action :run
  environment ({'HOME' => "#{HOME_DIR}"})
  ignore_failure true
  user node['chef_laptop']['user']
  group node['chef_laptop']['group']
end
