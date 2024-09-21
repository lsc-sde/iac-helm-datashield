#! /bin/env bash

NS=datashield
HELM_RELEASE_NAME=datashield
VERSION=0.0.1

microk8s.helm upgrade \
    --cleanup-on-fail \
    --install $HELM_RELEASE_NAME . \
    --namespace $NS \
    --create-namespace \
    --version $VERSION \
    --values ./values.yaml \
    --dry-run > ./logs/dry-run.yaml