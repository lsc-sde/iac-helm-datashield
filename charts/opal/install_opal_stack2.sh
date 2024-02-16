#! /bin/env bash

NS=opal2
HELM_RELEASE_NAME=opal2
VERSION=0.0.1

helm upgrade \
    --cleanup-on-fail \
    --install $HELM_RELEASE_NAME . \
    --namespace $NS \
    --create-namespace \
    --version $VERSION \
    --values ./values2.yaml \
    # --dry-run > dry-run.yaml
