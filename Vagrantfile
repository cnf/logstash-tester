# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  # config.vm.boot_mode = :gui
  config.vm.customize ["modifyvm", :id, "--memory", 2048]
  config.vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

  config.vm.forward_port 80, 8000
  config.vm.forward_port 8080, 8080
  config.vm.forward_port 9292, 9292
  config.vm.forward_port 9200, 9200
  config.vm.forward_port 9300, 9300

  config.vm.provision :chef_solo do |chef|
    # This path will be expanded relative to the project directory
    chef.cookbooks_path = [ "cookbooks", "~/.chef/cookbooks/" ]
    chef.add_recipe("apt")
    chef.add_recipe("java")
    chef.add_recipe("logstash_tester::server")
    chef.add_recipe("logstash_tester::kibana")
    chef.json = {
        java: {
          install_flavor: 'oracle',
          # remove_deprecated_packages: true,
          jdk_version: '7',
          oracle: {
            accept_oracle_download_terms: true,
          }
        },
        elasticsearch: {
          version: '0.20.2',
          min_mem: '512m',
          max_mem: '512m',
        },
        logstash: {
          confdir: '/vagrant/config',
          log_dir: '/vagrant/logs/',
          version: '1.1.9',
          debug: true,
          xms: '128m',
          xmx: '128m',
        }
      }
  end
end
