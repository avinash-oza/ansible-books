# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "debian/stretch64"
  # Do an apt get before running
# config.vm.provision "shell", inline: "sudo apt-get update"

  config.vm.provision "ansible" do |ansible|
      ansible.verbose = 'v'
      ansible.playbook = 'garage-door.yaml'
      ansible.groups = {
         "garage-door" => ['b1']
      }
  #   ansible.raw_arguments= ["-C"]
  end
  config.vm.synced_folder ".", "/vagrant"

  config.vm.define "b1" do |b1|
      b1.vm.box = "debian/stretch64"
  end
end
