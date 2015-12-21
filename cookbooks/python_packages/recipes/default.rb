HOME_DIR = "/home/#{node['chef_laptop']['user']}"

package 'python-pip'
package 'python-dev'
package "python-matplotlib"
package "python-netcdf"
package "python-tk"

# Connect to postgres db
package "python-psycopg2"

# # email helper
package "python-beautifulsoup"

# NetCDF
package "libhdf5-serial-dev"
package "libnetcdf-dev"

#Optional but very useful
package "ipython"
package "python-scipy"

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
 command "pip install pathlib"
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

## to do , replace all above lines with this
#python_requirements = ::File.join(data_services_dir, "python_requirements.txt")
#execute "python_requirements" do
    #command "pip install -r #{python_requirements}"
      #action  :nothing # Runs only if the data_services git repo updated
#end

package "xvfb"
