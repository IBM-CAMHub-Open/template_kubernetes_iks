function vercomp() {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

function prepareClusterConfig() {
    local baseDir=$(pwd)
    export WORK_DIR=${baseDir}/${CLUSTER_NAME}

    # Create temporary work dir
    mkdir -p $WORK_DIR

    # Persist the cluster config .yaml file
    echo "$CLUSTER_CONFIG" > $WORK_DIR/config.yaml

    # Persist the cluster certificate_authority .pem file
    export CLUSTER_CERTIFICATE_AUTHORITY_FILENAME=`echo "$CLUSTER_CONFIG" | grep certificate-authority | cut -d ":" -f 2 | tr -d '[:space:]'` \
        && echo "$CLUSTER_CERTIFICATE_AUTHORITY" > $WORK_DIR/$CLUSTER_CERTIFICATE_AUTHORITY_FILENAME
}


function isHelmVersion215OrLater() {
    helm215OrLater=0
    vercomp $HELM_VERSION '2.15.0'
    case $? in
        0)  helm215OrLater=0;;
        1)  helm215OrLater=0;;
        2)  helm215OrLater=1;;
    esac
    return $helm215OrLater
}


function installHelmLocally() {
    # Determine the platform architecture
    ARCH=`uname -a | rev | cut -d ' ' -f2 | rev`
    case $ARCH in
        x86_64)     PLATFORM='linux-amd64';;
        ppc64le)    PLATFORM='linux-ppc64le';;
    esac

    wget --quiet https://get.helm.sh/helm-v${HELM_VERSION}-${PLATFORM}.tar.gz -P ${WORK_DIR} \
        && tar -xzvf ${WORK_DIR}/helm-v${HELM_VERSION}-${PLATFORM}.tar.gz -C ${WORK_DIR}

}

function installKubectlLocally() {
    kversion=$(wget -qO- https://storage.googleapis.com/kubernetes-release/release/stable.txt)

    echo "Installing kubectl (version ${kversion}) into ${WORK_DIR}..."
    wget --quiet https://storage.googleapis.com/kubernetes-release/release/${kversion}/bin/linux/amd64/kubectl -P ${WORK_DIR}
    chmod +x ${WORK_DIR}/kubectl
}

function setupTillerAccount() {
    ## Prepare cache directory for kubectl
    cacheDir=${WORK_DIR}/.kube/http-cache
    mkdir -p ${cacheDir}

    echo "Creating and configuring tiller service account in cluster ${CLUSTER_NAME}..."
    export KUBECONFIG=${WORK_DIR}/config.yaml
    ${WORK_DIR}/kubectl --cache-dir ${cacheDir} --namespace kube-system create serviceaccount tiller
    ${WORK_DIR}/kubectl --cache-dir ${cacheDir} create clusterrolebinding tiller-clusterrolebinding \
	                    --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
}

function removeTillerAccount() {
    ## Prepare cache directory for kubectl
    cacheDir=${WORK_DIR}/.kube/http-cache
    mkdir -p ${cacheDir}

    echo "Removing tiller service account from cluster ${CLUSTER_NAME}..."
    export KUBECONFIG=${WORK_DIR}/config.yaml \
        && ${WORK_DIR}/kubectl --cache-dir ${cacheDir} --namespace kube-system delete serviceaccount tiller
    export KUBECONFIG=${WORK_DIR}/config.yaml \
        && ${WORK_DIR}/kubectl --cache-dir ${cacheDir} --namespace kube-system delete clusterrolebinding tiller-clusterrolebinding
}

