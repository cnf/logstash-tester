
# include_recipe "apache2::default"

# Set up the installation directory
directory node['kibana']['install_dir'] do
  owner         "www-data"
  group         "www-data"
  mode          0755
  action        :create
  recursive     true
end

# Download Kibana
remote_file "/tmp/kibana-#{node[:kibana][:version]}.tar.gz" do
  source  "https://github.com/rashidkpc/Kibana/archive/#{node['kibana']['version']}.tar.gz"
  mode      "0644"
  # checksum  node[:kibana][:checksum]
end

bash "gunzip kibana" do
  user  "root"
  cwd   "/tmp"
  code  %(gunzip kibana-#{node[:kibana][:version]}.tar.gz)
  not_if{ File.exists? "/tmp/kibana-#{node[:kibana][:version]}.tar" }
end

bash "extract kibana" do
  user  "root"
  cwd   node['kibana']['install_dir']
  code  <<-EOH
  tar -xf /tmp/kibana-#{node[:kibana][:version]}.tar --strip-components 1
  chown -R www-data:www-data #{node['kibana']['install_dir']}
  EOH
  not_if{ File.exists? "#{node[:kibana][:install_dir]}/KibanaConfig.rb" }
end

# Write config files
template "#{node['kibana']['install_dir']}/KibanaConfig.rb" do
  source  "KibanaConfig.rb.erb"
  owner   "www-data"
  group   "www-data"
  mode    0755
  action  :create
  variables(
    :conf => node[:kibana][:conf]
  )
end

template "/etc/init.d/kibana" do
  source "kibana-init.d.erb"
  owner "root"
  group "root"
  mode "0774"
end

directory "#{node['kibana']['install_dir']}/tmp" do
  owner         "www-data"
  group         "www-data"
  mode          0755
  action        :create
  recursive     true
end

gem_package "tzinfo" do
  action "install"
end

gem_package "sinatra" do
  action "install"
end

gem_package "json" do
  action "install"
end

gem_package "fastercsv" do
  action "install"
end

gem_package "daemons" do
  action "install"
end

service "kibana" do
  supports :restart => true, :reload => true, :status => true
  action [:enable, :start]
end
