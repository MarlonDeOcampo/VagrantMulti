#! /usr/bin/bash

# Auto-Install Main Server
# sudo -i
ip address show
echo "what is the main server IP"
read IP_ADDRESS
echo "Please set/select flannel interface listed above"
read INTERFACE
sudo apt install -y nfs-common
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-init --flannel-iface=$INTERFACE --bind-address=$IP_ADDRESS" sh -s -

echo "Sleeping for 5 seconds to wait for k3s to start"
sleep 5
echo "K3s installation complete!!"
echo "#########################################################################################################################################"
echo "This is the token that will be needed when you start to install another server or agents.Make sure to save it for later use"
echo "#########################################################################################################################################"
cat ../var/lib/rancher/k3s/server/node-token
echo "#########################################################################################################################################"
echo "This is the k3s config file that is needed for you to access the cluster using you local machine."
echo "#########################################################################################################################################"
cat ../etc/rancher/k3s/k3s.yaml
echo "#########################################################################################################################################"
echo "Create a .kube folder then create a config file without extension. paste this script then save"
echo "install the kubectl if you haven't done it yet using this command ( curl -LO 'https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl' )"
echo "You can access the cluster using the kubectl - execute this command to see all the list of nodes available ( kubectl get nodes )"
