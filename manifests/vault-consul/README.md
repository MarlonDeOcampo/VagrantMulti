## Installation of Vault and consul

Prerequisites

- Helm v3 and up


### How to install latest Helm by script

```sh
sudo apt update && sudo apt upgrade
sudo apt install curl
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```
- to fix the kubeconfig warning
```sh
  chmod go-r ~/.kube/config
```


- Add consul helm repo

```sh
    helm repo add hashicorp https://helm.releases.hashicorp.com
    helm repo update
```

- install consul via help using the consul-values.yaml file. Modify the file if neccessary.

```sh
    helm install consul hashicorp/consul --values consul-values.yaml --namespace hashicorp
```

- installation of Vault

```sh
    helm install vault hashicorp/vault --values vault-values.yaml --namespace hashicorp
```

### Vault Initialization

- detailed guide on how to initialize vault
  https://developer.hashicorp.com/vault/docs/commands/operator/init


- portforward vault-0 to access it on the web

```sh
    kubectl port-forward -n hashicorp vault-0 8200:8200
```
- go to the web and access the UI from  http://localhost:8200.

- input 5 key shares and 3 key threshold then click initialize

- download the unseal key then click continue to unseal

- execute this command to initialize and output json file for the needed token to unseal the vault

- open the downloaded json file then input 3 of the keys provided to continue to unlock the seal

- provide the root token to enter the vault management UI

- exit the port forward then proceed to port forward the other vault pods for the manual unsealing

- after you are done unsealling all the pods, execute kubectl get pods -A to check if all the pods are now running properly




### Secret injection to the kubernetes

- we are going to start the interactive shell session on vault-0

```sh
    kubectl exec -n hashicorp --stdin=true --tty=true vault-0 -- /bin/sh
```

- login to the vault using this command
- provide the root token

```sh
    vault login
```


- Enable kv-v2 secrets at the path 'secret'


```sh
    vault secrets enable -path=secret kv-v2
```

- lets create secret for our postgres database that we can use later during the setup of out postgress pod

```sh
    vault kv put secret/postgres/config POSTGRES_DB="postgres" POSTGRES_USER="postgres" POSTGRES_PASSWORD="secret"
```

- lets verify if the secrets were saved in our vault storage

```sh
    vault kv get secret/postgres/config
```

### configure the authentication of kubernetes to have a read only access in our vault storage


- enable the kubernetes auth

```sh
    vault auth enable kubernetes
```


- Configure the Kubernetes authentication method to use the location of the Kubernetes API.

```sh
    vault write auth/kubernetes/config kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    # token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    # kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

- success confirmation should be seen after the execution of both commands

- we have to define the vault policy that the access that will come from kubernetes has only read access to that particular address we define as path in the vault storage
- this command is a self explanatory so change the code according to your requirements

```sh
    vault policy write postgres - <<EOF
path "secret/data/postgres/config" {
  capabilities = ["read"]
}
EOF

```

- To apply this policy requires the authentication engine to define a role. A role binds policies and environment parameters together to create a login for the postgres application.

```sh
    vault write auth/kubernetes/role/postgres \
        bound_service_account_names="postgres" \
        bound_service_account_namespaces="database" \
        policies=postgres \
        ttl=24h
```

### Kubernetes Secret Injection Setup

- cd to postgres dir to deploy our database

- first deploy the secret.yaml, then the pvc and last the postgres-deployment.yaml

- check the postgres pod if it is running successfully without error

- let us check if the service account created during the execution of postgres deployment has successfully have access to the vault by executing this command

```sh
    kubectl exec -ti nameofthepod -n database -c postgres -- ls -l /vault/secrets 
```
- expected result 
"ls: /vault/secrets: No such file or directory
command terminated with exit code 1"

- run the annotation patch

```sh
    kubectl patch deployment postgres-deployment --patch "$(cat vault-patch-annotation.yaml)" -n database
```

- check logs if there is an error
```sh
    kubectl logs \
      $(kubectl get pod -l app=postgres -o jsonpath="{.items[0].metadata.name}") \
      --container vault-agent
```
- get the secret writen in our text file

```sh
    kubectl exec \
      $(kubectl get pod -l app=postgres -o jsonpath="{.items[0].metadata.name}") \
      --container postgres -- cat /vault/secrets/database-config.txt
```

- check if the database-config is now accessible 
```sh
    kubectl exec -ti postgres-deployment-688959d495-j9srp -n database -c postgres -- ls -l /vault/secrets
```

## Helper

### Injecting secrets to kubernetes
https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-sidecar

https://www.youtube.com/watch?v=R3EYd9YnShU



