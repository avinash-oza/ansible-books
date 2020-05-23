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
  config.vm.network "forwarded_port", guest: 80, host: 8108
  config.vm.network "forwarded_port", guest: 9100, host: 8109
  config.vm.network "forwarded_port", guest: 9101, host: 8110
  config.vm.network "forwarded_port", guest: 9102, host: 8111
  config.vm.network "forwarded_port", guest: 9103, host: 8112
  # Do an apt get before running
  config.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python-minimal"

  config.vm.provision "ansible" do |ansible|
      ansible.verbose = 'v'
      ansible.playbook = 'TEST_NAGIOS.yaml'
      ansible.groups = {
         "main-server" => ['b1']
      }
  #   ansible.raw_arguments= ["-C"]
  end
  config.vm.synced_folder ".", "/vagrant"

  config.vm.define "b1" do |b1|
      b1.vm.box = "debian/buster64"
  end
end
