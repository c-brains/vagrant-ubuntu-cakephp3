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
  }
})

include_cookbook "language-ja"
include_cookbook "itamae"
include_cookbook "ssl-certificate"
include_cookbook "phpenv"
