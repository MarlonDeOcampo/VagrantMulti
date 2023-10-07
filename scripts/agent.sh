#! /usr/bin/bash

# cat ../var/lib/rancher/k3s/server/token
ip address show
echo "Please provide server ip"
read IP_ADDRESS
echo "Please copy paste here the token from the server"
read TOKEN
echo "Please provide the flannel interface"
read INTERFACE
sudo apt update
sudo apt install -y nfs-common
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --flannel-iface=$INTERFACE --server https://$IP_ADDRESS:6443 --token $TOKEN" sh -
echo "Sleeping for 5 seconds to wait for k3s to start"
sleep 5
echo "K3s installation complete!!"