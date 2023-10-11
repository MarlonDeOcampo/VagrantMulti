## Install dashboard
```sh
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

- Apply the rolebinding

```sh
    kubectl apply -f adminuser-rolebinding.yaml
```

- generate token

```sh
    kubectl -n kubernetes-dashboard create token admin-user --duration=24h
```

- run proxy

```sh
    kubectl proxy
```

- access the dashboard using this address then input the generated token

```sh
    http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=default
```

## Deployment of dashboard guide
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
 
## Generating account guide
https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md