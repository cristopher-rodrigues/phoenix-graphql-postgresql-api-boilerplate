# Kubernetes

## Requirements

Please, run the following command before proceed in order to check if your system meets the requirements.

```bash
./bin/requirements.sh
```

## Running it locally with [k3d](https://github.com/rancher/k3d/)

Using k3d to orchestrate Kubernetes for development purposes.

### Download k3d

```bash
wget -q -O - https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash
```

### Creating a new single-node cluster

```bash
k3d create --api-port 6550 --publish 8081:80 --workers 2
```

### Set the cluster config to kubeconfig

```bash
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
```

```bash
kubectl cluster-info
```

Run the setup (to install helm charts, etc...)

```bash
make cluster-setup
```

If you want to check the API grab the `password`

```bash
cat $(k3d get-kubeconfig) | grep password
```

Acessing `https://localhost:6550/` using the password above and the user `admin` you should be able to see something like:

```json
{
  "paths": [
    "/api",
    "/api/v1",
    "/apis",
    "/apis/"
  ]
}
```

### K8s' environment setup

**PS: From now on all the commands must be executed from our app k8s/ dir**
  
- Apply the manifests

Create them all

```sh
make apply-manifests
```

- Make sure all of them were created right

```sh
make inspect-components
```

- Verify if all deployment's pods are running and healthy

```sh
make get-pods
```

- Verify pod logs

```sh
stern boilerplate --tail 20
```

Now you should be able to access in your browser:

```bash
http://localhost:8081/graphiql
```

- Cleanup the cluster

```bash
k3d delete
```

## Elasticsearch and Kafka

These are probably the most complex components on our boilerplate projects.
If you want to run the full project including these components follow the steps:

- [kafka](kafka/README.md)
- [elasticsearch](elasticsearch/README.md)
