# -*- mode: ruby -*-
# vi: set ft=ruby :

server_ip = "192.168.56.10"

server_script = <<-SHELL
  sudo -i
  # swapoff -a
  # sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
  # echo "127.0.1.1   k3s.newstars.io     server01" >> /etc/hosts
  export INSTALL_K3S_EXEC="--cluster-init --bind-address=#{server_ip} --node-external-ip=#{server_ip} --flannel-iface=eth1"
  curl -sfL https://get.k3s.io | sh -
  echo "Sleeping for 5 seconds to wait for k3s to start"
  sleep 5
  cp /var/lib/rancher/k3s/server/token /vagrant_shared
  cp /etc/rancher/k3s/k3s.yaml /vagrant_shared
  SHELL

server02_script = <<-SHELL
  sudo -i
  # swapoff -a
  # sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
  # echo "127.0.1.1   k3s.newstars.io     server02" >> /etc/hosts
  export K3S_TOKEN_FILE=/vagrant_shared/token
  export K3S_URL=https://#{server_ip}:6443
  export INSTALL_K3S_EXEC="server --flannel-iface=eth1 --disable-etcd"
  curl -sfL https://get.k3s.io | sh -
  SHELL


agent_script = <<-SHELL
  sudo -i
  # swapoff -a
  # sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
  # echo "127.0.1.1   k3s.newstars.io     agent" >> /etc/hosts
  export K3S_TOKEN_FILE=/vagrant_shared/token
  export K3S_URL=https://#{server_ip}:6443
  export INSTALL_K3S_EXEC="--flannel-iface=eth1"
  curl -sfL https://get.k3s.io | sh -
  SHELL

Vagrant.configure("2") do |config|
  config.vm.box = "generic/alpine314"
  config.vm.define "server01", primary: true do |server|
    server.vm.network "private_network", ip: server_ip
    server.vm.synced_folder "./shared", "/vagrant_shared"
    server.vm.hostname = "server01"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end
    server.vm.provision "shell", inline: server_script
  end

  config.vm.define "server02" do |server02|
    server02.vm.network "private_network", ip: "192.168.56.11"
    server02.vm.synced_folder "./shared", "/vagrant_shared"
    server02.vm.hostname = "server02"
    server02.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end
    server02.vm.provision "shell", inline: server02_script
end

  config.vm.define "agent" do |agent|
      agent.vm.network "private_network", ip: "192.168.56.12"
      agent.vm.synced_folder "./shared", "/vagrant_shared"
      agent.vm.hostname = "agent"
      agent.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = "1"
      end
      agent.vm.provision "shell", inline: agent_script
  end
end