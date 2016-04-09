# coding: utf-8

include_cookbook "ppa-ondrej-php70-repository"
include_cookbook "nginx"

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
