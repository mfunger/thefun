#!/usr/bin/env bash
export REPO_NAME="mojo2600"
export REPO_URL="https://mojo2600.github.io/pihole-kubernetes/"

repo_exists() {
    REPO_NAME_match=`helm repo list --output=json | jq -r '.[].name'`
    REPO_URL_match=`helm repo list --output=json | jq -r '.[].url'`
    echo $REPO_URL_match;
    echo $REPO_URL
    if [ "${REPO_NAME}" = "${REPO_NAME_match}" ] && [ "${REPO_URL}" = "{$REPO_URL_match}" ]; then
        return 0;
    else
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