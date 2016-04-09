# coding: utf-8

package 'mysql-server'

service "mysql" do
  action [:enable, :start]
end

template '/etc/mysql/conf.d/character_set.cnf' do
  notifies :restart, "service[mysql]"
end

execute "MySQL change root password" do
  command "/usr/bin/mysqladmin -u #{node.mysql.root_username} password #{node.mysql.root_password}"
  only_if "/usr/bin/mysql -u #{node.mysql.root_username} -e 'show databases;'"
end

mysql_options = "-h \"#{node.mysql.db_host}\" -u \"#{node.mysql.root_username}\" -p\"#{node.mysql.root_password}\""
if node.mysql.db_host == 'localhost' then
  mysql_allow_host = node.mysql.db_host;
else
  mysql_allow_host = '%';
end

execute "create database for application" do
  command "mysql -e \"CREATE DATABASE #{node.mysql.app_db_name} DEFAULT CHARACTER SET #{node.mysql.charset} COLLATE #{node.mysql.collation};\" #{mysql_options}"
  only_if ("test \"$(mysql -e \"SHOW DATABASES LIKE '#{node.mysql.app_db_name}';\" #{mysql_options} --silent --skip-column-names)\" != '#{node.mysql.app_db_name}'")
end

node.mysql.app_users.each do |user_type,app_user|
  execute "create user,grant: #{app_user.username}" do
    command "mysql -e \"GRANT #{app_user.priv_types} ON #{node.mysql.app_db_name}.* TO '#{app_user.username}'@'#{mysql_allow_host}' IDENTIFIED BY '#{app_user.password}';\" #{mysql_options}"
    only_if ("test \"$(mysql -e \"SELECT User FROM mysql.db WHERE Host='#{mysql_allow_host}' AND Db='#{node.mysql.app_db_name}' AND User='#{app_user.username}';\" #{mysql_options} --silent --skip-column-names)\" != '#{app_user.username}'")
    notifies :run, "execute[mysql_flush_privileges]"
  end
end

if node.mysql.app_test_db_name then
  execute "create database for test" do
    command "mysql -e \"CREATE DATABASE #{node.mysql.app_test_db_name} DEFAULT CHARACTER SET #{node.mysql.charset} COLLATE #{node.mysql.collation};\" #{mysql_options}"
    only_if ("test \"$(mysql -e \"SHOW DATABASES LIKE '#{node.mysql.app_test_db_name}';\" #{mysql_options} --silent --skip-column-names)\" != '#{node.mysql.app_test_db_name}'")
  end
  app_user = node.mysql.app_users.app_user
  execute "create grant for test" do
    command "mysql -e \"GRANT ALL ON #{node.mysql.app_test_db_name}.* TO '#{app_user.username}'@'#{mysql_allow_host}' IDENTIFIED BY '#{app_user.password}';\" #{mysql_options}"
    only_if ("test \"$(mysql -e \"SELECT User FROM mysql.db WHERE Host='#{mysql_allow_host}' AND Db='#{node.mysql.app_test_db_name}' AND User='#{app_user.username}';\" #{mysql_options} --silent --skip-column-names)\" != '#{app_user.username}'")
    notifies :run, "execute[mysql_flush_privileges]"
  end
end

execute "mysql_flush_privileges" do
  command "mysql -e \"FLUSH PRIVILEGES;\" #{mysql_options}"
  action :nothing
end
