#!/usr/bin/env bash

export REPO_NAME="hashicorp"
export REPO_URL="https://helm.releases.hashicorp.com"


# Install Helm Chart to local

repo_exists() {
    REPO_NAME_match=`helm repo list --output=json | jq -r '.[].name'`
    REPO_URL_match=`helm repo list --output=json | jq -r '.[].url'`
    echo $REPO_URL_match;
    echo $REPO_URL
    if [ "${REPO_NAME}" = "${REPO_NAME_match}" ] && [ "${REPO_URL}" = "{$REPO_URL_match}" ]; then
        return 0;
    else
        echo "The repository isn't local."
        return 1;
    fi
}
repo_exists
RESULT=$?
echo $RESULT

if [ $RESULT != 0 ]; then {
    echo "Adding ${REPO_NAME}@${REPO_URL}"
    helm repo add $REPO_NAME $REPO_URL
    helm repo update
}
else
    echo "Updating ${REPO_NAME}@${REPO_URL}"
    helm repo update
fi

# Install Vault to local cluster

export VAULT_HELM_VERSION="0.28.0"
export VAULT_APP_VERSION="1.16.1"

export VAULT_K8S_NAMESPACE="vault"
export VAULT_HELM_RELEASE_NAME="vault"
export VAULT_SERVICE_NAME="vault-internal"
export K8S_CLUSTER_NAME="cluster.local"

export WORKDIR=$(PWD)/temp
if [ ! -d $WORKDIR ]; then
    mkdir -p $WORKDIR
fi
ssh-keygen -t rsa -b 4096 -f ${WORKDIR}/vault.local


