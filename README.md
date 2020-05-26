# Managed Kubernetes Service within IBM Cloud
Copyright IBM Corp. 2019, 2019 \
This code is released under the Apache 2.0 License.

## Overview
This terraform template deploys a kubernetes cluster within IBM Cloud's Kubernetes (IKS) service.\

Via this template, a configurable number of worker nodes can be deployed.

## Prerequisites
The user must be assigned the following access policies to deploy and manage clusters within IKS
  * The Administrator IBM Cloud IAM platform role for IBM Cloud Kubernetes Service
  * The Administrator IBM Cloud IAM platform role for IBM Cloud Container Registry
  * The Writer or Manager IBM Cloud IAM service role for IBM Cloud Kubernetes Service

## Template input parameters

| Parameter name         | Parameter description |
| :---                   | :---        |
| region                 | IBM Cloud region in which to deploy the cluster |
| cluster_name           | Name of the IKS cluster |
| resource\_group\_name  | Name of the IBM Cloud resource group. You must have access to at least one resource group in IBM Cloud |
| private\_vlan\_id      | Virtual network that allows private communication between worker nodes in this cluster. Can be retrieved by running bx cs vlans <location> |
| public\_vlan\_id       | Virtual network that allows secured communication between the worker nodes and the IBM-managed master node. Can be retrieved by running bx cs vlans <location> |
| subnet_id              | The portable subnet to use for cluster. A list of available subnets can be retrieved by running bx cs subnets |
| num_workers            | Number of workers to be deployed in the cluster |
| datacenter             | IBM Cloud datacenter in which to create the cluster |
| machine_type           | Machine type for the worker node(s) |
| isolation              | Hardware isolation ('shared', 'dedicated' or 'baremetal') |
| kube_version           | Kubernetes version for the cluster. Specify 'latest' for the most recent kubernetes version supported by the Kubernetes Service, or a version number in the X.Y[.Z] format (e.g. 1.13 or 1.13.5).  The most recent maintenance release for the specified version will be selected. |
| deploy_tiller          | Indicates whether tiller should be deployed into Kubernetes cluster |
| helm_version           | Helm version to be used to deploy the tiller into the Kubernetes cluster |
