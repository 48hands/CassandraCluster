# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  (1..3).each do |no|
    name = "nosql#{no}"
    config.vm.define name do |node|
      node.vm.provider "virtualbox" do |vm|
        vm.name = name
        vm.customize ["modifyvm", :id, "--memory", "2048"]
      end
      node.vm.box = "centos/7"
      node.vm.hostname = name
      node.vm.network "private_network", ip: "192.168.33.4#{no}"
      node.vm.provision "shell", inline: "sudo systemctl stop firewalld"
      node.vm.provision "shell", inline: "sudo systemctl disable firewalld"
      node.vm.provision "shell", inline: "sudo systemctl restart network"
    end
  end
end
