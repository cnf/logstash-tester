include_recipe "logstash_tester::default"
include_recipe "logstash_tester::elasticsearch"

# installation
remote_file "#{node['logstash']['basedir']}/logstash-#{node['logstash']['version']}.jar" do
  owner "root"
  group "root"
  mode "0755"
  source node['logstash']['source_url']
  not_if { File.exists?("#{node['logstash']['basedir']}/logstash-#{node['logstash']['version']}.jar") }
end

link "#{node['logstash']['basedir']}/logstash-server.jar" do
  to "#{node['logstash']['basedir']}/logstash-#{node['logstash']['version']}.jar"
  notifies :restart, "service[logstash]"
end

directory "#{node['logstash']['confdir']}/conf.d" do
  action :create
  recursive true
  mode "0755"
  owner 'logstash'
  group 'logstash'
end

template "/etc/init.d/logstash" do
  source "logstash-init.d.erb"
  owner "root"
  group "root"
  mode "0774"
  variables(:config_file => "logstash.conf",
            :basedir => "#{node['logstash']['basedir']}")
end

service "logstash" do
  supports :restart => true, :reload => true, :status => true
  action [:enable, :start]
end
