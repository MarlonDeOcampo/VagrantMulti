What is the role of local path provisioner?

The Local Path Provisioner provides a way for Kubernetes users to use the local storage in each node by enabling the ability to create persistent volume claims using local storage on the respective node.

How to install?

    1. Install the provisioner:
        <code> kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml </code>

    2. Set the local-path provisioner as default:
        <code> kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'</code>


Creating a secret
    echo "password" | base64