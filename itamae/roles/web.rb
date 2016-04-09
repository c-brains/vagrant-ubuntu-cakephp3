# coding: utf-8

# default settings (for Development Environment)
node.reverse_merge!({
  'app_root' => '/var/www/app',
  'nginx' => {
    'default' => {
      'server_name' => 'www.example.com'
    }
  },
  'ssl_certificate' => {
    'default' => {
      'path_certificate_bundle' => '/etc/ssl/certs/www.example.com-bundle.crt',
      'path_private_key' => '/etc/ssl/private/www.example.com.private.key'
    }
  },
  'cakephp' => {
    'debug' => true
  },
  'mysql' => {
    'db_host' => 'localhost',
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_general_ci',
    'app_db_name' => 'cakeapp',
    'app_test_db_name' => 'cakeapp_test',
  },
})

include_cookbook "language-ja"
include_cookbook "itamae"
include_cookbook "ssl-certificate"
include_cookbook "phpenv"
include_cookbook "mysql-client"
include_cookbook "mysql-server"
