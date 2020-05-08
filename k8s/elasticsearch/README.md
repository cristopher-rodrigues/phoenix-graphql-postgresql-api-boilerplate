# Elasticsearch

`PS: Assuming you already have the k3d structure running...`

In this simple example we're using the official [all-in-one](https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-quickstart.html) from elastic.co.

## Setup

Install custom resource definitions and the operator with its RBAC rules:

```bash
kubectl apply -f all-in-one.yaml
```

Monitor the operator logs:

```bash
kubectl -n elastic-system logs -f statefulset.apps/elastic-operator
```

Apply a simple [Elasticsearch cluster specification](https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-deploy-elasticsearch.html), with one Elasticsearch node:

```bash
kubectl apply -f elasticsearch.yaml
```

Monitor cluster health and creation progress

```bash
kubectl get elasticsearch
```

Wait it until the `HEALTH` is equals to `green`
You can see that one Pod is in the process of being started:

```bash
kubectl get pods --selector='elasticsearch.k8s.elastic.co/cluster-name=quickstart'
```

Access the logs for that Pod:

```bash
kubectl logs -f quickstart-es-default-0
```

A ClusterIP Service is automatically created for your cluster:

```bash
kubectl get service quickstart-es-http
```

Get the credentials

```bash
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
```

From your local workstation, use the following command in a separate terminal:

```bash
kubectl port-forward service/quickstart-es-http 9200
```

```bash
curl -u "elastic:$PASSWORD" -k "https://localhost:9200"
```

If you want to expose if from the cluster perspective you can follow the same we did for the Boilerplate app:

Expose the Elasticsearch's service port through the k3d cluster creation `--publish 9200:9200`

```bash
k3d create --api-port 6550 --publish 8081:80 --publish 9200:9200 --workers 2
```

Then, apply the ingress

```bash
kubectl apply -f ingress.yaml
```

Internally on the cluster, it'd be as the following

```bash
curl -u "elastic:$PASSWORD" -k "https://quickstart-es-http:9200"
```

## Update the boilerplate app

Once we the Elasticsearch running on the cluster we can update our app's k8s's manifests to include it.

`URL=https://elastic:REPLACE_TO_USE_THE_PASSWORD@quickstart-es-http:9200`

Update the `app/secrets.yaml` file to include the elastic url ([base64](../secrets.md))

```yaml
BOILERPLATE_ELASTIC_URL: "BASE64_URL"
```

To keep it simple we're including the password on the URL (but we could make it a sealedsecret).

(Re)Generate the `app/sealed-secrets.yaml` following the same instructions in [secrets.md](../secrets.md)
Replace the `app/secrets.yaml` and `app/sealed-secrets.yaml`

```bash
kubectl replace -f app/secrets.yaml && kubectl replace -f app/sealed-secrets.yaml
```

And finally recreate the boilerplate's app deployment

```bash
kubectl delete -f app/deployment.yaml && kubectl create -f app/deployment.yaml
```
