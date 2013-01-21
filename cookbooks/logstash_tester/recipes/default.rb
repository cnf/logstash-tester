include_recipe "java"

group 'logstash' do
  system true
end

user 'logstash' do
  group 'logstash'
  home "/var/lib/logstash"
  system true
  action :create
  manage_home true
end

directory node['logstash']['confdir'] do
  action :create
  owner "root"
  group "root"
  mode "0755"
end

directory node['logstash']['basedir'] do
  action :create
  owner "root"
  group "root"
  mode "0755"
end

directory node['logstash']['pid_dir'] do
  action :create
  owner node['logstash']['user']
  group node['logstash']['group']
  mode "0755"
end

directory node['logstash']['log_dir'] do
  action :create
  owner node['logstash']['user']
  group node['logstash']['group']
  mode "0755"
end
