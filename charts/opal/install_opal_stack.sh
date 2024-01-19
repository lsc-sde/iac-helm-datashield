# helm repo add chgl https://chgl.github.io/charts
# helm repo update
#====================================================================
#cp -r /mnt/c/Users/vishnu.chandrabalan/.kube/config ~/.kube/config


#CURRENTAKSCONTEXT=$(kubectl config current-context)
#AKSNAME=aks-datashield-dev-01
#kubectl config use-context $AKSNAME
#====================================================================
# need a mechanism to change this between prd and dev
NS=opal
HELM_RELEASE_NAME=opal01
VERSION=0.0.1

helm upgrade \
    --cleanup-on-fail \
    --install $HELM_RELEASE_NAME . \
    --namespace $NS \
    --create-namespace \
    --version $VERSION \
 #   --values ./values.yaml \
    # --dry-run > dry-run.yaml

#====================================================================
#kubectl config use-context $CURRENTAKSCONTEXT
#====================================================================
