# coding: utf-8

include_cookbook "ppa-ondrej-php70-repository"
include_cookbook "nginx"

# PHP
%w(php7.0-fpm).each do |pkg|
  package pkg do
    action :install
  end
end

service "php7.0-fpm" do
  action [:enable, :start]
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
