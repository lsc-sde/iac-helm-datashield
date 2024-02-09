#! /bin/env bash

NS=opal1
HELM_RELEASE_NAME=opal1
VERSION=0.0.1

helm upgrade \
    --cleanup-on-fail \
    --install $HELM_RELEASE_NAME . \
    --namespace $NS \
    --create-namespace \
    --version $VERSION \
    --values ./values1.yaml \
    # --dry-run > dry-run.yaml
