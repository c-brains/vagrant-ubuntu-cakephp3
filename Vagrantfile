# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.plugin.add_dependency "vagrant-itamae"
  config.plugin.add_dependency "vagrant-vbguest"

  config.vm.box = "ubuntu/xenial64"

  config.vm.define :default do |default|
    default.vm.network "private_network", ip: "192.168.33.10", auto_config: true

    WEB_SERVER_GID = 33

    default.vm.synced_folder "./app", "/var/www/app",
      :nfs => false,
      :owner => "ubuntu",
      :group => WEB_SERVER_GID,
      :mount_options => ["dmode=775,fmode=775"]

    default.vm.synced_folder ".", "/vagrant",
      :nfs => false,
      :owner => "ubuntu",
      :group => "ubuntu",
      :mount_options => ["dmode=775,fmode=775"]


    default.vm.provision :itamae do |config|
      config.sudo = true
      config.recipes = File.join(__dir__, "itamae", "bootstrap.rb")
      config.yaml = File.join(__dir__, "itamae", "node.yml")
      #config.log_level = 'debug'
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory = "2048"
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off", "--natdnshostresolver1", "off", "--paravirtprovider", "kvm"]
  end
end
