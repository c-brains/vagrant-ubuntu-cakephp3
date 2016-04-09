# coding: utf-8

include_cookbook "ppa-ondrej-php70-repository"
include_cookbook "nginx"

# PHP
%w(php7.0-fpm php7.0-curl php7.0-intl php7.0-mbstring php7.0-sqlite3).each do |pkg|
  package pkg do
    action :install
  end
end

service "php7.0-fpm" do
  action [:enable, :start]
end

# composer
execute "composer install" do
  command "curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer"
  not_if "test $(which /usr/local/bin/composer)"
end

directory "/home/vagrant/.composer" do
  owner 'vagrant'
  group 'vagrant'
end

# composer parallel install plugin https://github.com/hirak/prestissimo
execute "prestissimo install (composer parallel install plugin)" do
  user "vagrant"
  command "composer global require hirak/prestissimo"
  not_if ("composer global show -i 2>&1 | grep -qi hirak/prestissimo")
end

template "/etc/nginx/sites-available/01-#{node['nginx']['default']['server_name']}.conf" do
  source "templates/etc/nginx/sites-available/app.conf.erb"
  mode '0644'
  variables(
    vhost: node['nginx']['default']
  )
  notifies :reload, "service[nginx]"
end

link "/etc/nginx/sites-enabled/01-#{node['nginx']['default']['server_name']}.conf" do
  cwd "/etc/nginx/sites-enabled"
  to "/etc/nginx/sites-available/01-#{node['nginx']['default']['server_name']}.conf"
end
