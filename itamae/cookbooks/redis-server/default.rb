# coding: utf-8


package "redis-server"

# redis-server
service "redis-server" do
  action [:enable, :start]
end
