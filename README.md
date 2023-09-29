K3s Cluster Installation
==================== 


### Prerequisite
#####  Base installation for all of the machines
 - all target machine should have linux server disto installed
 - static IP address for all of the machines
 - NFS common kernel installed 
  
#####  Host machine
  - kubctl installed
  - ssh key copied to all target machines

### Installation

- Copy the master-server.sh to the main server machine via ssh

```sh
scp -r FileLocation user@ServerMachineIPaddress ~/$whoami/install.sh"
```

- Ssh login to the target server then execute the install.sh.
During the installation, the script will ask you the server IP address and the Network Interface name so make sure you have
them already before starting the script

- After the installation, The script will provide you the generated token and kube config information, so it is better to copy and paste it to a notepad because we are going to use them during the installation of other machines (agents and or other servers)


### Using the host machine for the installation of k3s of other machines

- run the command in your host computer to start the installation of kubectl

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

- after the installation, we can now use the host for all the future installation.

- to check if it is already connected to the main server, check the listed nodes in the cluster by executing this command

```sh
kubectl get nodes
```
- it should show you the master server on the list 

- we can now start to install the secondary server, execute the kubctl get nodes command again but this time with wide --watch flag so that we can see the secondary server connection to the main server when the installation is done

```sh
kubectl get nodes -o wide --watch
```

### Installation of Secondary Server

- Copy the non-master-server.sh to the target machine. We can also use the same copy command we used during the master server installation.
- SSH Log in to the target machine then execute the install.sh from the terminal
- provide the token, Net Interface the IP address of the server that we saved in the notepad
- after the installation, the master server should update the list of node connected to it


### Installation of agents
- The instruction is the same as on how we installed the secondary server. The only difference is that the script.
- Copy the agent.sh to the target machine then ssh login to it to execute the script
- after the installation. The Main server should detect the newly installed agent to its list of nodes.

