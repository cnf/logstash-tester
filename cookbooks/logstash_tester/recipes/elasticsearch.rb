# include_recipe "apache2::default"

group 'elasticsearch' do
  system true
end

user 'elasticsearch' do
  group 'elasticsearch'
  home node['elasticsearch']['install_dir']
  system true
  action :create
  manage_home true
end

directory '/var/run/elasticsearch' do
  action :create
  owner 'elasticsearch'
  group 'elasticsearch'
  mode "0755"
end

directory '/var/log/elasticsearch' do
  action :create
  owner 'elasticsearch'
  group 'elasticsearch'
  mode "0755"
end

directory '/var/lib/elasticsearch' do
  action :create
  owner 'elasticsearch'
  group 'elasticsearch'
  mode "0755"
end

# Set up the installation directory
directory node['elasticsearch']['install_dir'] do
  owner         "elasticsearch"
  group         "elasticsearch"
  mode          0755
  action        :create
  recursive     true
end

# Download Kibana
remote_file "/tmp/elasticsearch-#{node['elasticsearch']['version']}.tar.gz" do
  source "http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}.tar.gz"
  mode      "0644"
  # checksum  node[:kibana][:checksum]
end

bash "extract elasticsearch" do
  user  "root"
  cwd   node['elasticsearch']['install_dir']
  code  <<-EOH
  tar -xzf /tmp/elasticsearch-#{node['elasticsearch']['version']}.tar.gz --strip-components 1
  chown -R www-data:www-data #{node['elasticsearch']['install_dir']}
  EOH
  not_if{ File.exists? "#{node['elasticsearch']['install_dir']}/file.conf" }
end

# Write config files
template "#{node['elasticsearch']['install_dir']}/config/elasticsearch.yml" do
  source  "elasticsearch.yml.erb"
  owner   "www-data"
  group   "www-data"
  mode    0755
  action  :create
  variables(
    'conf' => node['elasticsearch']['conf']
  )
end

template "/etc/init.d/elasticsearch" do
  source "elasticsearch-init.d.erb"
  owner "root"
  group "root"
  mode "0774"
end

service "elasticsearch" do
  supports :restart => true, :reload => true, :status => true
  action :enable
end
