<!-- postgres://{{ .Data.username }}:{{ .Data.password }}@postgres.postgres.svc:5432/wizard?sslmode=disable -->

## Note:
    "when using the hostname of postgres, you should use the pod IP address instead of Service IP address"

- check if we dont have access to the vault secret before patching annotation

```sh
    kubectl exec -ti payment-service-79cd8f6547-c9l7w -n api -c payment-service -- ls -l /vault/secrets
```

expected result 

```sh
     /vault/secrets 
    ls: cannot access '/vault/secrets': No such file or directory
    command terminated with exit code 2
```

- lets run the annotation patch

- make sure that vault role that was created has the api namespace included to the bound namespace array before the patch else, the initialization of pods will not start

```sh
    kubectl patch deployment payment-service --patch "$(cat vault-patch-annotation.yaml)" -n api
```

- kubectl get pod -n api  to check if it successufully initialized

- check the vault secret value

```sh
    kubectl exec -ti payment-service-76c4965d98-zmllh -n api -c payment-service -- ls -l /vault/secrets
```