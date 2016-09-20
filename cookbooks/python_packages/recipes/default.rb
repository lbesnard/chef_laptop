HOME_DIR = "/home/#{node['chef_laptop']['user']}"

python_package = [%w{python-pip python-dev python-matplotlib python-netcdf4 python-tk python-psycopg2 python-beautifulsoup libhdf5-serial-dev libnetcdf-dev ipython python-scipy python-rpy2 python-pythonmagick}]
python_package.flatten.each do |a_package|
  package a_package
end


# install netcdf4
execute "python netCDF4" do
 command "pip install netCDF4"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end

# various python packages
execute "python - various packages" do
 command "pip install pathlib; pip install grequests"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end

# install selenium for river heights
execute "python selenium" do
 command "pip install selenium; pip install pyvirtualdisplay; pip install pdfminer"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end

# powerline
execute "python - powerline" do
 command "pip install powerline-status; pip install pyuv"
  action :run
  environment ({'HOME' => '#{HOME_DIR}'})
  ignore_failure true
  user "root"
end



## to do , replace all above lines with this
#python_requirements = ::File.join(data_services_dir, "python_requirements.txt")
#execute "python_requirements" do
    #command "pip install -r #{python_requirements}"
      #action  :nothing # Runs only if the data_services git repo updated
#end
