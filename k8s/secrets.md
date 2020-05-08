# Kubernetes Secrets

For this case we're using [kubeseal](https://github.com/bitnami-labs/sealed-secrets) as the encryption mechanism for safe-stored secrets.

Using the concept of SealedSecrets as templates for secrets we have [secrets.yaml](secrets.yaml) which is the "template" for all our secrets and would contain all the base64 values (non-versioned) and the [sealed-secrets.yaml](sealed-secrets.yaml) which is the object Sealed for our secrets.

## Adding

To add a new secret you will the following steps:

0. Grab all the "real" base64 values from the prefered Vault you're using to long-term store for the current secrets' values.

1.  Include the new secret's value (as base64) on [secrets.yaml](secrets.yaml) with all the rest

```bash
echo -n my-raw-secret-value | base64
```

2.  Update the [sealed-secrets.yaml](sealed-secrets.yaml) to encrypt and include the new value, by running the kubeseal CLI (assuming you're have it [installed](https://github.com/bitnami-labs/sealed-secrets/releases)).

```bash
kubeseal \
  --controller-name=$(kubectl get services -n kube-system --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep sealed-.\*) \
  --controller-namespace=kube-system \
  <secrets.yaml >sealed-secrets.yaml -o yaml
```

3.  Apply it on cluster (make sure you're using the right context)

```bash
kubectl replace -f sealed-secrets.yaml
```

4.  Check if it works

```bash
kubectl describe secret boilerplate
```
