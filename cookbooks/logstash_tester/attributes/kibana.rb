default['kibana']['version']     = "kibana-ruby"
default['kibana'][:install_dir] = "/opt/kibana"

# The following are configuration options for Kibana.
# See templates/default/config.php.erb for a description of each
default['kibana']['conf'][:elastic_server]    = "localhost"
default['kibana']['conf'][:elastic_port]      = 9200
default['kibana']['conf'][:type]              = ""
default['kibana']['conf'][:results_per_page]  = 50
default['kibana']['conf'][:export_delimiter]  = ","
default['kibana']['conf'][:default_fields]    = [
  "@type", "@tags", "@source_host", "@source_path", "@timestamp", "@source" 
]
