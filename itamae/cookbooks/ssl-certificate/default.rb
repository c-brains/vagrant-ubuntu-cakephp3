# coding: utf-8

%w(openssl).each do |pkg|
  package pkg do
    action :install
  end
end

execute "generate self certificate" do
  command <<-CMD
    openssl req -new -newkey rsa:2048 -sha256 -x509 -nodes \
    -set_serial 1 \
    -days 3650 \
    -subj "/C=JP/ST=Kanagawa/L=Yokohama City/CN=#{node['nginx']['default']['server_name']}" \
    -out #{node['ssl_certificate']['default']['path_certificate_bundle']} \
    -keyout #{node['ssl_certificate']['default']['path_private_key']}
  CMD
  not_if "test -f #{node['ssl_certificate']['default']['path_certificate_bundle']}"
end
