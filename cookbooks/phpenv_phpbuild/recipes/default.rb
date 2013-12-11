execute "Update yum Development Tools" do
  command "yum -y groupupdate \"Development Tools\""
end

%w{git libxml2-devel libcurl-devel libjpeg-turbo-devel libpng-devel giflib-devel gd-devel libmcrypt-devel sqlite-devel libtidy-devel libxslt-devel}.each do |name|
  package name do
    action :install
  end
end

bash "Install phpenv with php-build plugin" do
  cwd "/home/vagrant"
  user "vagrant"
  group "vagrant"
  creates "/home/vagrant/.phpenv"

  code <<-EOH
  export PHPENV_ROOT=/home/vagrant/.phpenv
  curl https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh | bash
  mkdir /home/vagrant/.phpenv/plugins
  cd /home/vagrant/.phpenv/plugins && git clone git://github.com/CHH/php-build.git
  echo 'PATH=$HOME/.phpenv/bin:$PATH # Add phpenv to PATH for scripting' >> /home/vagrant/.bashrc
  echo 'eval \"$(phpenv init -)\"' >> /home/vagrant/.bashrc
  EOH
end

node[:php].each do |php|
  version = php["version"]
  phpdir = "/home/vagrant/.phpenv/versions/" + php["version"]

  bash "Install PHP " + version do
    user "vagrant"
    group "vagrant"
    creates phpdir
    code <<-EOH
    export PATH="/home/vagrant/.phpenv/bin:$PATH"
    export PHP_BUILD_CONFIGURE_OPTS="#{node[:php_configure_options]}"
    phpenv install #{version}
    echo \"date.timezone =Asia/Tokyo\" >> #{phpdir}/etc/php.ini
    EOH
  end
  template phpdir + "/etc/php-fpm.conf" do
    user "vagrant"
    group "vagrant"
    source "php-fpm.conf." + php["ini_file"] + ".erb"
    variables(
      :port => php["fpm_port"]
    )
  end
end

package "supervisor" do
  action :install
end
template "/etc/supervisord.conf" do
  source "supervisord.conf.erb"
  variables(
    :php => node['php']
  )
end
service "supervisord" do
  action [:start, :enable]
end

execute "Set phpenv global" do
  user "vagrant"
  command "/home/vagrant/.phpenv/bin/phpenv global " + node[:php_global_version]
end

package "nginx" do
  action :install
end
template "/etc/nginx/conf.d/virtual.conf" do
  source "nginx_virtual.conf.erb"
  variables(
    :php => node['php']
  )
end

service "nginx" do
  action [:start, :enable]
end
