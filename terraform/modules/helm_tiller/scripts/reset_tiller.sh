#!/bin/bash
source $SCRIPTS_PATH/functions.sh

## Prepare work environment
prepareClusterConfig

## Install necessary utilities
installHelmLocally
installKubectlLocally

## Remove tiller service account
removeTillerAccount

# helm reset
source $SCRIPTS_PATH/functions.sh
vercomp $HELM_VERSION '2.8.2'
case $? in
    0)  TILLER_CONNECTION_TIMEOUT=' --tiller-connection-timeout 60';;
    1)  TILLER_CONNECTION_TIMEOUT=' --tiller-connection-timeout 60';;
    2)  TILLER_CONNECTION_TIMEOUT=''
esac

export KUBECONFIG=$CLUSTER_NAME/config.yaml \
    && $CLUSTER_NAME/$PLATFORM/helm reset --force $TILLER_CONNECTION_TIMEOUT
