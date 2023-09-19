Vagrant.configure("2") do |config|

  # this is the vagrant box that all our nodes will be using. 
  config.vm.box = "bento/ubuntu-23.04" 
    # this is the shared folder between the nodes and our host
  config.vm.synced_folder "./shared", "/vagrant", type: "virtualbox"
  config.vm.provider "virtualbox" do |vb|
    # each node will have 3g of memory
    vb.memory = "3072"
     # each node will have 2 cores
    vb.cpus = "2"
  end
  
  config.vm.define "server01",primary: true do |server01| 
      # Hostname will be used to ssh with the node "vagrant ssh <Hostname>"
      server01.vm.hostname = "server01"
      server01.vm.network "public_network", ip: "192.168.0.201", bridge: "enp2s0"
      server01.vm.network "private_network", ip: "192.168.56.101"
      server01.vm.provision "shell", inline: <<-SHELL
        apt-get update
        # We added write config mode so that we dont need to use sudo everytime we run the kubectl - should be for testing purposes only and should not be applied in production 
        # instead we should grab the kubeconfig file and bring it to the local and change the config for local use
        curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable-agent --write-kubeconfig-mode 664 --tls-san 192.168.0.201" sh - 
        # Check for Ready node, takes ~30 seconds 
        k3s kubectl get node 
      SHELL
  end

  config.vm.define "server02" do |server02|
      server02.vm.hostname = "server02"
      server02.vm.network "public_network", ip: "192.168.0.202", bridge: "enp2s0"
      server02.vm.network :private_network, ip: "192.168.56.102"  
      server02.vm.provision "shell", inline: <<-SHELL
        apt-get update
        # We added write config mode so that we dont need to use sudo everytime we run the kubectl - should be for testing purposes only and should not be applied in production 
        # instead we should grab the kubeconfig file and bring it to the local and change the config for local use
        curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable-agent --write-kubeconfig-mode 664 --tls-san 192.168.0.202" sh - 
        # Check for Ready node, takes ~30 seconds 
        k3s kubectl get node 
      SHELL
  end

  config.vm.define "agent" do |agent|
    agent.vm.hostname = "agent"
    agent.vm.network "public_network", ip: "192.168.0.203", bridge: "enp2s0"
    agent.vm.network "private_network", ip: "192.168.56.103"
  end
end

