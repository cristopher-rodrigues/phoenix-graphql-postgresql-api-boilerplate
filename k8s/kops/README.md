# KOPS

## Install

Follow [these instructions](https://kops.sigs.k8s.io/getting_started/install/)

## AWS

Kops for [AWS](https://kops.sigs.k8s.io/getting_started/aws/)

ASSUMING that domain-name is already registered and the DNS IS FULLY managed by AWS Route 53 (`boilerplate.io`).

```bash
export AWS_REGION=us-east-1 && \ # get from tf
  export KOPS_STATE_STORE=s3://boilerplate-kops-state-store && \ # get from tf
  export KOPS_CLUSTER_NAME=kops.boilerplate.com # get from tf
```

Create cluster configuration

```bash
kops create cluster --zones $AWS_REGION $KOPS_CLUSTER_NAME
```

Customize Cluster Configuration

```bash
kops edit cluster $KOPS_CLUSTER_NAME
```

Build the Cluster

```bash
kops update cluster --yest $KOPS_CLUSTER_NAME
```

```bash
kubectl get nodes && kops validate cluster
```

You can look at all system components with the following command.

```bash
kubectl -n kube-system get po
```
