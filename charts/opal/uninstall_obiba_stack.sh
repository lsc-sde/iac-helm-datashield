# helm repo add chgl https://chgl.github.io/charts
# helm repo update
#====================================================================
cp -r /mnt/c/Users/vishnu.chandrabalan/.kube/config ~/.kube/config


CURRENTAKSCONTEXT=$(kubectl config current-context)
AKSNAME=aks-datashield-dev-01
kubectl config use-context $AKSNAME
#====================================================================
# need a mechanism to change this between prd and dev
NS=obiba
HELM_RELEASE_NAME=obiba01
VERSION=0.0.1

helm uninstall $HELM_RELEASE_NAME \
    --namespace $NS \

#====================================================================
kubectl config use-context $CURRENTAKSCONTEXT
#====================================================================
