# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos64_ja"
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/3657281/centos64_ja.box"

  config.vm.network :private_network, ip: "192.168.33.14"

  #config.omnibus.chef_version = "11.4.0"

  config.vm.synced_folder "./public_html", "/public_html", :create => true, :owner=> 'vagrant', :group=>'vagrant', :extra => 'dmode=777,fmode=666'

  config.vm.provider :virtualbox do |vb|
    #vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "base"
    chef.add_recipe "phpenv_phpbuild"
    chef.json = {
      :php_global_version => "5.5.0",
      :php_configure_options => "",
      :php => [
        {
          :version => "5.3.26",
          :ini_file => "53",
          :fpm_port => "9053",
          :http_port => "8053"
        },
        {
          :version => "5.4.16",
          :ini_file => "54",
          :fpm_port => "9054",
          :http_port => "8054"
        },
        {
          :version => "5.5.0",
          :ini_file => "55",
          :fpm_port => "9055",
          :http_port => "8055"
        }
      ]
    }
  end
end
