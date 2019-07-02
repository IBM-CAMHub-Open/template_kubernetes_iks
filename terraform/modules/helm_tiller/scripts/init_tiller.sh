#!/bin/bash
source $SCRIPTS_PATH/functions.sh

## Prepare work environment
prepareClusterConfig

## Install necessary utilities
installHelmLocally
installKubectlLocally

## Setup tiller service account
setupTillerAccount

# helm init
vercomp $HELM_VERSION '2.8.2'
case $? in
    0)  TILLER_CONNECTION_TIMEOUT=' --tiller-connection-timeout 300';;
    1)  TILLER_CONNECTION_TIMEOUT=' --tiller-connection-timeout 300';;
    2)  TILLER_CONNECTION_TIMEOUT=''
esac

vercomp $HELM_VERSION '2.7.2'
case $? in
    0)  FORCE_UPGRADE=' --force-upgrade';;
    1)  FORCE_UPGRADE=' --force-upgrade';;
    2)  FORCE_UPGRADE=''
esac

## Configure tiller within the cluster
export KUBECONFIG=$CLUSTER_NAME/config.yaml \
    && $CLUSTER_NAME/$PLATFORM/helm init --service-account tiller --upgrade $FORCE_UPGRADE $TILLER_CONNECTION_TIMEOUT

