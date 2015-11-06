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

github_repos = [  "https://github.com/lbesnard/dotfiles", \
                  "https://github.com/lbesnard/River_Height_Tasmania",
                  "git@github.com:aodn/chef.git", \
                  "git@github.com:aodn/chef-private.git", \
                  "https://github.com/aodn/harvesters", \
                  "https://github.com/aodn/imos-user-code-library", \
                  "https://github.com/reicast/reicast-emulator" ]

github_repos.flatten.each do |repo_name|
  # keep only the repo name part of the string
  name=repo_name.rpartition('/').last
  name.slice! ".git"

  git "#{GITHUB_REPO}/#{name}" do
    repository repo_name
    reference "master"
    action :checkout
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