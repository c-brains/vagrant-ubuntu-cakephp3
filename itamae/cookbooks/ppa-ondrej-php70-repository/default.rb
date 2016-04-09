# coding: utf-8

package 'python-software-properties'

# ppa:ondrej/php-7.0 Repository
execute 'Install ppa:ondrej/php-7.0 Repository' do
  command 'LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php; apt-get update'
  not_if 'test -f /etc/apt/sources.list.d/ondrej-ubuntu-php-wily.list'
end
