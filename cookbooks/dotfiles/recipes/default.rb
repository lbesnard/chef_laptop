git "/home/lbesnard/dotfiles_clone" do
  repository "http://github.com/lbesnard/dotfiles"
  reference "master"
  action :sync
  user "lbesnard"
end



execute "dotfiles" do
  command "bash ~/dotfiles_clone/install"
  action :run
  environment ({'HOME' => '/home/lbesnard'})
  ignore_failure true
end
