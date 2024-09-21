#! /bin/bash

NS=datashield
HELM_RELEASE_NAME=datashield
VERSION=0.0.1

microk8s.helm uninstall $HELM_RELEASE_NAME --namespace $NS