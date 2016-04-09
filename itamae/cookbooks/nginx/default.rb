# coding: utf-8

%w(nginx openssl).each do |pkg|
  package pkg do
    action :install
  end
end

execute "/etc/ssl/dhparam.pem 生成" do
  command "openssl dhparam 2048 -out /etc/ssl/dhparam.pem"
  not_if "test -f /etc/ssl/dhparam.pem"
end

# nginx
service "nginx" do
  action [:enable, :start]
end
