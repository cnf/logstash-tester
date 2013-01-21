default['logstash']['version'] = '1.1.9'
default['logstash']['source_url'] = 'https://logstash.objects.dreamhost.com/release/logstash-1.1.9-monolithic.jar'
default['logstash']['install_method'] = 'jar' # Either `source` or `jar`
default['logstash']['xms'] = '512M'
default['logstash']['xmx'] = '512M'
default['logstash']['java_opts'] = '-Djava.net.preferIPv4Stack=true'
default['logstash']['gc_opts'] = '-XX:+UseParallelOldGC'
default['logstash']['debug'] = true
default['logstash']['home'] = '/opt/logstash'
