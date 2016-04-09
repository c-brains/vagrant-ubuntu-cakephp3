# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.plugin.add_dependency "vagrant-itamae"
  config.plugin.add_dependency "vagrant-vbguest"

  config.vm.box = "ubuntu/wily64"

  config.vm.define :default do |default|
    default.vm.provision :itamae do |config|
      config.sudo = true
      config.recipes = File.join(__dir__, "itamae", "bootstrap.rb")
      config.yaml = File.join(__dir__, "itamae", "node.yml")
    end
  end
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory = "1024"
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off", "--natdnshostresolver1", "off", "--paravirtprovider", "kvm"]
  end
end
