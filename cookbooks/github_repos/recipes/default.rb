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

github_repos = [  "http://github.com/lbesnard/dotfiles" \
                  "http://github.com/lbesnard/River_Height_Tasmania" \
                  "http://github.com/lbesnard/dotfiles" \
                  "git@github.com:aodn/data-services.git" \
                  "git@github.com:aodn/aodn-portal.git" \
                  "git@github.com:aodn/harvesters.git" \
                  "git@github.com:aodn/imos-user-code-library.git" \
                  "git@github.com:reicast/reicast-emulator.git" ]

github_repos.flatten.each do |repo_name|
    git "#{GITHUB_REPO}/#{name}" do
      repository repo_name
      reference "master"
      action :sync
      user node['chef_laptop']['user']
    end
end

execute "dotfiles" do
  command "bash ~/github_repo/dotfiles/install"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user node['chef_laptop']['user']
end

# install cheat
execute "cheat_install" do
  command "pip install docopt pygments;cd #{GITHUB_REPO}/dotfiles/libs/cheat; python setup.py install"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end
