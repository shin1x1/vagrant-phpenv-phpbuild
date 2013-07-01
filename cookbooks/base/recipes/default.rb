#execute "Update timezone" do
#  command "cp -a /usr/share/zoneinfo/#{node[:timezone][:tz]} /etc/localtime"
#end

execute "Flush all iptables rules" do
  command "/sbin/iptables -F"
end
service "iptables" do
  action [:disable, :stop]
end

execute "Install yum epel repository" do
  command "rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm"
  not_if "rpm -qa | grep -q 'epel-release'"
end

execute "Install yum remi repository" do
  command "rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
  not_if "rpm -qa | grep -q 'remi-release'"
end

execute "Install yum pggd repository" do
  command "rpm -ivh http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm"
  not_if "rpm -qa | grep -q 'pgdg-centos92'"
end

%w{git vim-enhanced zsh bind-utils telnet}.each do |name|
  package name do
    action :install
  end
end

package "postfix" do
  action :install
end
service "postfix" do
  action [:start, :enable]
end

package "ntp" do
  action :install
end
service "ntpd" do
  action [:start, :enable]
end

template "/home/vagrant/.vimrc" do
  source ".vimrc"
  owner "vagrant"
  group "vagrant"
end
