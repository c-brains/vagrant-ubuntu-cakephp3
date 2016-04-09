# coding: utf-8

# 
# Itamae Setup
# 
%w{gcc bundler ruby-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

directory '/var/itamae' do
  owner 'vagrant'
  group 'vagrant'
end

# Itamae Gemfile
remote_file '/var/itamae/Gemfile' do
  owner 'vagrant'
  group 'vagrant'
end

# itamae install
execute "itamae install" do
  command "sudo -u vagrant bundle install --gemfile=/var/itamae/Gemfile --path /var/itamae/vendor/bundle"
  not_if "test -f /var/itamae/Gemfile.lock"
end
