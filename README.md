K3s Cluster Installation
==================== 


### Prerequisite
#####  Base installation for all of the machines
 - all target machines should have linux server disto installed
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
During the installation, the script will ask you the server IP address and the Network Interface name of the main server, so make sure you have
them already before starting the script

- After the installation, The script will provide you the generated token and kube config information, so it is better to copy and paste it to a notepad because we are going to use them during the installation of other machines (agents and or other servers)


### Using the host machine for the installation of packages into the cluster

- run the command in your host computer to start the installation of kubectl

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

- after the installation, we can now use the host for all the future installation. except the installation of k3s to other target machines

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
- provide the token, Net Interface the IP address of the server that we have saved in the notepad earlier
- after the installation, the master server should update the list of nodes connected to it


### Installation of agents
- The instruction is the same as on how we installed the secondary server. The only difference is the script to use.
- Copy the agent.sh to the target machine then ssh login to it to execute the script
- after the installation. The Main server should detect the newly installed agent to its list of nodes connected it.


Installation of Containers and other prerequisite files
-------------------------------------------------------


### Installation of metallb

We can now use the host machine to deploy containers and install other needed software to make our cluster do its job

- go to the directory of the cloned repo the cd to manifests/metallb
- execute the command to start the installation of metallb

```sh
  kubectl apply -f metallb.yaml
```

### Expose the Traefik Dashboard

- cd to the traefik folder then execute the following command
- we can edit the htpassword.yaml to match your desired password -  use htpassword generator that is freely available online. or we can use our TLS     certificate instead of using the htpassword secret 

```sh
kubectl apply -f htpassword.yaml
```

- next the middleware installation

```sh
kubectl apply -f auth-middleware.yaml
```

- and last our traefik dashboard deployment
```sh
kubectl apply -f traefik-dashboard.yaml
```

- after the deployment, we have to add the IP address of the server and the a dns name the you like to the host file of our local machine
- cd to /etc/
- then execute this command

```sh
vi hosts
```
- add your desired value to the end of the file example: 192.168.1.1    mydns.com

- save the file then now we can access the dashboard on our web browser
- put the dns name that you have added to the hosts file, in our case it is mydns.com and press enter to see the dashboard


### Creating an NFS Kurbernetes provision

- make sure that you have all the details of your nfs server shared path and the IP address 
- go to the nfs