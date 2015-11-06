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
