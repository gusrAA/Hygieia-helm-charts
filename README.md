# Hygieia-helm-charts

A Helm Chart for deploying Hygieia in Kubernetes

## Prerequisites

* Kubernetes 1.11+
* Helm 

## Adding the Repository
The charts are published to gh-pages which can act as a Helm repository. You'll need to add it to your list of repositories before you can use the chart.

To add the repository use the following command:

```
$ helm repo add hygieia https://gusraa.github.io/Hygieia-helm-charts/
```

## Installing the Chart
To install the chart use the following command:

```
$ helm install --name <release name> 

```

## Example deployment

Look at the "deploy" branch
