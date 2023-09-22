# VagrantMulti


# Setting up all the environments

# We can use baremetals or virtual-machines to setup our environment
# We can even use Vagrant to automate the process of setting up our virtual machines in our local

# Installing using the baremetal

# => When installing using the bare metal, we have to install the ubuntu/Linux using a bootable usb installer
# => Do all the neccessary setups such as renaming the host name, setting up the network ip and etc to make sure that we don't have to worry about them later when we start installing our k3s cluster
# => once the OS is running and you are able to login, proceed with the instruction part after installing virtualbox and vagrant


#when using virtual machines, there are some prerequisite softwares that we have to install first

1. # virtualbox version 6.1 # this is the latest version that I found with less problem installing 
    # the k3s and vagrant during this time of documentation. 
    # This may vary depends on the version of vagrant and what version of virtual box it currently support. 

2. # vagrant @latest version # if you decided to automate the process of installing the initial os and packages


# Prerequisite file Installation
# Please see the documentation of each particular software to see the latest version 

# Here we are installing Vitual machine 6.1 and Vagrant 2.3.7

1. # open the terminal and execute the following command
 
    "sudo apt update && sudo apt upgrade"

    "sudo apt install virtualbox -y"

  # you can launch the virtual box by executing "virtualbox" to the console

2. # We are now installing the Vagrant using the terminal as well. Execute the command below - this is only when you decide to automate the process.

    "sudo apt install vagrant -y"

    # We can validate if the installation was successful by checking the version

    "vagrant --version"

    # If there is no version shown after the execution of the sudo command. Please try to do it again from the start 
    # or check the Vagrant documention for more guided instructions


# Presumambly, we are done with the installation without any problems. We can now proceed on creating our nodes using Vagrant

# Before anything else, what is Vagrant? 

 "Vagrant is a tool that automates the installation of virtualbox's images. Without Vagrant, installation of OS, Softwares and or packages may consume
a lot of time specially when you are just about to try or trying to learn all the softwares you want to install on our virtual environment 
as well as all the softwares that are dependent on the OS you initially installed on the virtual machine."

# Vagrant runs in the background without a nice UI interface. You can only see the progress in the terminal where you have executed the command.
# Vagrant also dependent on a file called "Vagrantfile" that should be manually created in the presently active directory you are at or the target directory you want to execute the command. 
# To make this more clearer, lets start to do it in action


# Go to your target folder or create a folder to any location that you've like. 
 # For me, My Vagrantfile is located on the same location as where this document resides. 
    # Note: I won't explain here what each code can do inside the Vagrant file because I have a separate guide for those who decided not to use the Vagrant for automation, 
    # All codes where explained there. If you will check the Vagrant file, almost each line is properly documented, You will probably can understard each line of codes without me
    # explaining it. If you can't still complehend, please proceed to the tutorial that is specifically created for non vagrant users. 

 # The Vagrantfile should be in a Title case format or the first letter word is capital, else the script wont work.
 # Open the terminal and make sure that you are in the right directory -(same directory as where the Vigrant file is)
 # execute the command
   "vagrant up"


# wait until you are able to type again on the terminal. Please check if there were errors during the installation. 
# At the end of the installation, you will normally see 3 running virtualbox machines when you open the virtualbox app
# When you seems to feel that all were good and there were no errors during the installation, you can if the k3s is perfectly working at this point

# go to the terminal and type this command
"Vagrant ssh server01"

# This script will allow us to login to our primary node which is the server01
# after execution of the code. the terminal current address should be redirected to the server01 address
# execute this command to check the connected nodes in our cluster
"sudo -i"
"kubectl get node"

# When you see 3 nodes were up and running. That means our installation were successfull



# ========== How to configure Traefik loadbalancer =================

"https://qdnqn.com/how-to-configure-traefik-on-k3s/#:~:text=K3s%20is%20managing%20Traefik%20using,needed%20details%20as%20shown%20below.&text=It's%20important%20to%20say%20that,f%20traefik%2Dcustom%2Dconf."

# traefik dashboard enable

1. # Edit the file "/var/lib/rancher/k3s/server/manifests/traefik-config.yaml" or create any yaml file in your host computer then paste this code
2. # apply the script using the command "kubectl apply -f <Name of your yaml file including the extension>"

apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    dashboard:
      enabled: true
    ports:
      traefik:
        expose: true # this is not recommended in production deployments, but I want to be able to see my dashboard locally
    logs:
      access:
        enabled: true

3. add dns to your /etc/hosts file using vim "example: 192.168.56.10    newstars.traefik.com" 

4. access the dashboard in the browser #it must have a back slash at the end of the address else it won't work
"http://newstars.traefik.com:9000/dashboard/ "

# or just do this for tempoarary display of dashboard
"kubectl port-forward $(kubectl get pod -n kube-system -l app.kubernetes.io/name=traefik -o NAME) -n kube-system 9000:9000"


# =========== Install kubectl to the host computer to access clusters ===============

mkdir ~/.kube
vi ~/.kube/config
export KUBECONFIG=~/.kube/config
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
# try to get node info
"kubectl get nodes"
