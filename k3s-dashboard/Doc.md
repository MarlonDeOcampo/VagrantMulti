## Installation steps for K3s dashboard

### Installation steps for K3s dashboard. On master node, create a folder called dashboard:

1. ssh to master_server node
2. execute the following command

```sh
mkdir ~/k3s-dashboard
cd ~/k3s-dashboard
GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
sudo k3s kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml
```

or directly install it withou ssh

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
```

3. apply the 2 yaml file 

```sh
kubectl apply -f service-account.yaml
kubectl apply -f cluster-role-binding.yaml
```

4. Apply the traefik Ingress as well

```sh
kubectl apply -f dashboard-trafik.yaml
```

### If you run without certificates, e.g. in a test environment, you then need to configure traefik to skip certificate checks by adding the following line to the config map for traefik, first launch the config map editor:

```sh
kubectl -n kube-system edit cm traefik
```

### Then add the following line to the top of the toml part:.


```sh
insecureSkipVerify = true
```

- like this one 
```sh
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  traefik.toml: |
    # traefik.toml
    logLevel = "debug"
    insecureSkipVerify = true
    defaultEntryPoints = ["http","https"]
```

- Then relaunch the traefik pod by scaling down/up:

```sh
kubectl -n kube-system scale deploy traefik --replicas 0
kubectl -n kube-system scale deploy traefik --replicas 1
```


https://gist.github.com/jannegpriv/06427e4ecc2a17f317a4bebc32b6445c

https://saturncloud.io/blog/exposing-kubernetes-dashboard-with-clusterip-service-externally-using-ingress-rules/