Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-23.04" 
  config.vm.synced_folder "./shared", "/vagrant", type: "virtualbox"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "3072"
    vb.cpus = "2"
  end
  config.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y apache2
    SHELL
  end
  
  config.vm.define "server01",primary: true do |server01| 
      server01.vm.hostname = "server01"
      server01.vm.network "public_network", bridge: "enp2s0"
      server01.vm.network "private_network", ip: "192.168.56.101"
  end

  config.vm.define "server02" do |server02|
      server02.vm.hostname = "server02"
      server02.vm.network "public_network", bridge: "enp2s0"
      server02.vm.network :private_network, ip: "192.168.56.102"  
  end

  config.vm.define "agent" do |agent|
    agent.vm.hostname = "agent"
    agent.vm.network "public_network", bridge: "enp2s0"
    agent.vm.network "private_network", ip: "192.168.56.103"
  end
end

